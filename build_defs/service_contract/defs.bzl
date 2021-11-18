load("@rules_proto//proto:defs.bzl", "proto_library")

def service_contract(name, **kwargs):
  deps = kwargs.pop("deps", default = [])
  proto_library(
    name = name,
    deps = deps + ["@go_googleapis//google/api:annotations_proto"],
    **kwargs,
  )
