import gleam/option.{type Option, None}
import gleam/result
import gleam/string

pub type Dsn {
  Dsn(
    public_key: String,
    secret_key: Option(String),
    uri: String,
    project_id: String,
  )
}

/// Creates a `Dsn` from a dsn string. dsn string is the usual way that sentry
/// SDKs provide the dsn.
/// An example dsn: "https://public:secret@sentry.example.com/1"
pub fn from_string(dsn_string: String) -> Result(Dsn, String) {
  // we get `#("https", "public:secret@sentry.example.com/1")` here
  use #(protocol, rest) <- result.try(case dsn_string {
    "http://" <> rest -> Ok(#("http", rest))
    "https://" <> rest -> Ok(#("https", rest))
    _ -> Error("Invalid DSN. DSN should start with the http or https")
  })

  // we get `#("public:secret", "sentry.example.com/1")` here
  use #(auth_string, rest) <- result.try(
    string.split_once(rest, "@")
    |> result.replace_error(
      "Invalid DSN. At lease public key should be present",
    ),
  )

  // we get `#("public", "secret")` here
  use #(public_key, secret_key) <- result.try(
    string.split_once(auth_string, ":")
    |> result.or(Ok(#(auth_string, "")))
    |> result.replace_error("Invalid DSN. Could not figure out the public key"),
  )

  // we get `#("sentry.example.com", "1")` here
  use #(host, project_id) <- result.try(
    string.split_once(rest, "/")
    |> result.replace_error("Invalid DSN. Seems that project id is not present"),
  )

  Ok(Dsn(
    public_key:,
    secret_key: string.to_option(secret_key),
    uri: protocol <> "://" <> host,
    project_id:,
  ))
}
