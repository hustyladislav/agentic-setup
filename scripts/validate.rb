#!/usr/bin/env ruby
# Repo checks: SKILL.md frontmatter, JSON/YAML parse, relative Markdown links. Exit 1 on any problem.
Encoding.default_external = Encoding::UTF_8
require "yaml"
require "json"

Dir.chdir(File.expand_path("..", __dir__))
IGNORED = %r{\A(\.git|\.agents|\.claude/skills|node_modules)/}
files = `git ls-files -co --exclude-standard`.split("\n").reject { |f| f.match?(IGNORED) || !File.file?(f) }
errors = []

files.grep(%r{(\A|/)SKILL\.md\z}).each do |f|
  m = File.read(f).match(/\A---\n(.*?)\n---\n/m)
  next errors << "#{f}: no frontmatter" unless m
  fm = begin
    YAML.safe_load(m[1])
  rescue StandardError => e
    errors << "#{f}: frontmatter does not parse (#{e.message})"
    next
  end
  %w[name description].each do |k|
    errors << "#{f}: frontmatter `#{k}` missing or empty" unless fm.is_a?(Hash) && fm[k].is_a?(String) && !fm[k].strip.empty?
  end
  folder = File.basename(File.dirname(f))
  errors << "#{f}: name `#{fm['name']}` != folder `#{folder}`" if fm.is_a?(Hash) && fm["name"] && fm["name"] != folder
end

files.grep(/\.json\z/).each do |f|
  JSON.parse(File.read(f))
rescue JSON::ParserError => e
  errors << "#{f}: invalid JSON (#{e.message[0, 80]})"
end

files.grep(/\.ya?ml\z/).each do |f|
  YAML.safe_load(File.read(f), aliases: true)
rescue StandardError => e
  errors << "#{f}: invalid YAML (#{e.message[0, 80]})"
end

# Assets are templates: their links resolve in the target repo, not here.
files.grep(/\.md\z/).reject { |f| f.start_with?("skills/agentic-setup/assets/") }.each do |f|
  text = File.read(f).gsub(/```.*?```/m, "").gsub(/`[^`\n]*`/, "")
  text.scan(/\]\(([^)\s]+)\)/).flatten.each do |link|
    next if link.match?(%r{\A([a-z]+:|#|mailto:)}i)
    target = File.expand_path(link.split("#").first.to_s, File.dirname(f))
    errors << "#{f}: broken link #{link}" unless File.exist?(target)
  end
end

puts errors
puts "validate: #{files.size} files checked, #{errors.size} problem(s)"
exit(errors.empty? ? 0 : 1)
