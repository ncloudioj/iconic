ExUnit.start()

{:ok, files} = File.ls("./test/util")

Enum.each(
  files,
  fn file ->
    unless String.starts_with?(file, ".") do
      Code.require_file("util/#{file}", __DIR__)
    end
  end
)
