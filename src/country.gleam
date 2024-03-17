import gleam/dict.{type Dict}
import gleam/list
import gleam/dynamic
import country_format
import gleam/json

// Consider https://hexdocs.pm/juno for a more chill decoder

pub type CountryName {
  CountryName(common: String, official: String)
}

pub fn country_name_decoder() {
  dynamic.decode2(
    CountryName,
    dynamic.field("common", dynamic.string),
    dynamic.field("official", dynamic.string),
  )
}

pub type Currency {
  Currency(name: String, symbol: String)
}

fn currency_decoder() {
  dynamic.decode2(
    Currency,
    dynamic.field("name", dynamic.string),
    dynamic.field("symbol", dynamic.string),
  )
}

fn currencies_decoder() {
  country_format.decoder(dynamic.string, currency_decoder())
}

pub type Country {
  Country(
    name: CountryName,
    cca2: String,
    cca3: String,
    cioc: String,
    un_member: Bool,
    currencies: Dict(String, Currency),
    capital: List(String),
    region: String,
    subregion: String,
  )
}

pub fn country_decoder() {
  dynamic.decode9(
    Country,
    dynamic.field("name", country_name_decoder()),
    dynamic.field("cca2", dynamic.string),
    dynamic.field("cca3", dynamic.string),
    dynamic.field("cioc", dynamic.string),
    dynamic.field("unMember", dynamic.bool),
    dynamic.field("currencies", currencies_decoder()),
    dynamic.field("capital", dynamic.list(dynamic.string)),
    dynamic.field("region", dynamic.string),
    dynamic.field("subregion", dynamic.string),
  )
}

pub fn countries_decoder() {
  dynamic.list(country_decoder())
}

pub fn countries_from_json(
  json_string: String,
) -> Result(List(Country), json.DecodeError) {
  json.decode(from: json_string, using: countries_decoder())
}

pub fn get_sample_data() {
  "{\r\n        \"name\": {\r\n            \"common\": \"Germany\",\r\n            \"official\": \"Federal Republic of Germany\",\r\n            \"nativeName\": {\r\n                \"deu\": {\r\n                    \"official\": \"Bundesrepublik Deutschland\",\r\n                    \"common\": \"Deutschland\"\r\n                }\r\n            }\r\n        },\r\n        \"tld\": [\r\n            \".de\"\r\n        ],\r\n        \"cca2\": \"DE\",\r\n        \"ccn3\": \"276\",\r\n        \"cca3\": \"DEU\",\r\n        \"cioc\": \"GER\",\r\n        \"independent\": true,\r\n        \"status\": \"officially-assigned\",\r\n        \"unMember\": true,\r\n        \"currencies\": {\r\n            \"EUR\": {\r\n                \"name\": \"Euro\",\r\n                \"symbol\": \"E\"\r\n            }\r\n        },\r\n        \"idd\": {\r\n            \"root\": \"+4\",\r\n            \"suffixes\": [\r\n                \"9\"\r\n            ]\r\n        },\r\n        \"capital\": [\r\n            \"Berlin\"\r\n        ],\r\n        \"altSpellings\": [\r\n            \"DE\",\r\n            \"Federal Republic of Germany\",\r\n            \"Bundesrepublik Deutschland\"\r\n        ],\r\n        \"region\": \"Europe\",\r\n        \"subregion\": \"Western Europe\",\r\n        \"languages\": {\r\n            \"deu\": \"German\"\r\n        }\r\n}"
}
