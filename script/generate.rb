#!/usr/bin/env brew ruby

tap = Tap.fetch("davidchall/hep")

directories = ["_data/formula", "formula"]
FileUtils.rm_rf directories + ["_data/formula_canonical.json"]
FileUtils.mkdir_p directories

html_template = IO.read "_formula.html.in"

tap.formula_names.each do |n|
  f = Formulary.factory(n, ignore_errors: true)
  IO.write("_data/formula/#{f.name.tr("+", "_")}.json", "#{JSON.pretty_generate(f.to_hash)}\n")
  IO.write("formula/#{f.name}.html", html_template.gsub("title: $TITLE", "title: \"#{f.name}\""))
end
IO.write("_data/formula_canonical.json", "#{JSON.pretty_generate(tap.formula_renames.merge(tap.alias_table))}\n")
