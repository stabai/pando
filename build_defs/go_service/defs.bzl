load(
    "@io_bazel_rules_go//go:def.bzl",
    "go_binary",
    "go_library",
    "GoLibrary",
    "GoSource",
    "go_context",
)
load("@io_bazel_rules_go//proto:def.bzl", "go_proto_library")
load("@io_bazel_rules_go//proto/wkt:well_known_types.bzl", "PROTO_RUNTIME_DEPS", "WELL_KNOWN_TYPES_APIV2")

DEFAULT_GO_GRPC_COMPILERS = ["@io_bazel_rules_go//proto:go_grpc"]

def go_service_contract(name, **kwargs):
  deps = kwargs.pop("deps", default = [])
  plugins = kwargs.pop("plugins", default = [])
  go_proto_library(
    name = name,
    compilers = DEFAULT_GO_GRPC_COMPILERS + plugins,
    deps = deps + ["@go_googleapis//google/api:annotations_go_proto"],
    **kwargs,
  )

def _gen_server_srcs(ctx):
  service_name = ctx.attr.full_service_name.split('.')[-1]
  go_contract = ctx.attr.go_contract[GoLibrary]
  main_go_file = ctx.actions.declare_file("%s_main.go" % ctx.attr.name)
  ctx.actions.expand_template(
    template = ctx.file._template,
    output = main_go_file,
    substitutions = {
      "{SERVICE_CONTRACT_GO_IMPORTPATH}": go_contract.importpath,
      "{SERVICE_NAME}": service_name,
    },
  )
  return [DefaultInfo(files = depset([main_go_file]))]

gen_server_srcs = rule(
  implementation = _gen_server_srcs,
  attrs = {
        "full_service_name": attr.string(mandatory = True),
        "contract": attr.label(providers = [ProtoInfo], mandatory = True),
        "go_contract": attr.label(providers = [GoLibrary], mandatory = True),
        "_template": attr.label(
            default = Label("//build_defs/go_service/pandomium/template:main.go"),
            allow_single_file = True,
        ),

  },
)

def go_pandomium_service(name, full_service_name, contract, go_contract, service_deps = [], **kwargs):
  gen_srcs_name = "%s_gen" % name
  gen_lib_name = "%s_genlib" % name
  gen_server_srcs(
    name = gen_srcs_name,
    full_service_name = full_service_name,
    contract = contract,
    go_contract = go_contract,
  )
  go_library(
    name = gen_lib_name,
    srcs = kwargs.pop("srcs", default = []) + [":" + gen_srcs_name],
    deps = kwargs.pop("deps", default = []),
    data = kwargs.pop("data", default = []),
    embed = kwargs.pop("embed", default = []),
  )
  go_binary(
    name = name,
    embed = [":%s" % gen_lib_name],
    **kwargs,
  )
