load("@rules_proto//proto:defs.bzl", "ProtoInfo")
#load("@build_bazel_rules_nodejs//:providers.bzl", "JSModuleInfo")

def _ts_service_gen_impl(ctx):
  print(ctx.files.proto)

ts_service_gen = rule(
  implementation = _ts_service_gen_impl,
  attrs = {
      "proto_name": attr.string(),
      "proto": attr.label(providers = [ProtoInfo]),
      "ts_proto": attr.label(),
  },
  executable = False,
)
