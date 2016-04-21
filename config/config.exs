use Mix.Config

config :flasked,
  otp_app: :flasked,
  map_file: "priv/flasked.exs"

if Mix.env in ~w(docs)a do
  config :ex_doc, :markdown_processor, ExDoc.Markdown.Cmark
end
