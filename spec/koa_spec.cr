require "./spec_helper"

describe Koa do
  it "compiles" do
    Koa
  end

  it "creates open api json" do
    api_json : String?
    Koa.init "Demo API", version: "API_VERSION", desc: "API for Demo app"
    Koa.schema "result", {
      "success" => Bool,
      "error"   => String?,
    }
    Koa.schema "filter", {
      "key"   => String,
      "type"  => String,
      "value" => String, # | Int32 | Int64 | Float32,
    }
    Koa.schema "subscription", {
      "id"         => String,
      "name"       => String,
      "created_at" => Int64,
      "filters"    => ["filter"],
    }

    Koa.describe "Creates a new subscription"
    Koa.tags ["admin", "downloader", "subscription"]
    Koa.body schema: {
      "name"    => String,
      "filters" => ["filter"],
    }
    Koa.response 200, schema: "result"
    post "/api/admin/plugin/subscriptions" do |env|
      response = {
        "success" => true,
      }
      env.response.content_type = "application/json"
      (env.response.print response).to_json
    end

    doc = Koa.generate
    api_json = doc.to_json if doc

    File.read("spec/assets/doc1.json").should eq api_json
  end
end
