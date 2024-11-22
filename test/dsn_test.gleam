import gleam/option
import gleeunit/should

import dsn.{Dsn, from_string}

pub fn proper_dsn_string_can_be_converted_to_dsn_type_test() {
  "https://sef8w82criyw:riw0qf1f4@sentry.example.com/832023842034234"
  |> from_string
  |> should.be_ok
  |> should.equal(Dsn(
    public_key: "sef8w82criyw",
    secret_key: option.Some("riw0qf1f4"),
    uri: "https://sentry.example.com",
    project_id: "832023842034234",
  ))
}
