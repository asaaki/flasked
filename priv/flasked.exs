%{
  flasked: [
    info: ~S"""
    If you can read this, than you have not configured your release/app in a way to
    load the correct mapping file.

    Please consult the documentation for Flasked:

        iex(0)> h Flasked

    Or have a look at the README.md of Flasked.
    """,

    x_example: {:flasked, :FLASKED_X_EXAMPLE, :dict_of_integers, [error: "No ENV var was set."]}
  ]
}
