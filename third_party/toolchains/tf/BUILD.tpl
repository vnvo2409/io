package(default_visibility = ["//visibility:public"])

cc_library(
    name = "tf_core_header_lib",
    hdrs = [":tf_core_header_include"],
    include_prefix = "tensorflow/core",
    strip_include_prefix = "include_core",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "tf_c_header_lib",
    hdrs = [":tf_c_header_include"],
    include_prefix = "tensorflow/c",
    strip_include_prefix = "include_c",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "libtensorflow_framework",
    srcs = [":libtensorflow_framework.so"],
    #data = ["lib/libtensorflow_framework.so"],
    visibility = ["//visibility:public"],
)

%{TF_CORE_HEADER_GENRULE}
%{TF_C_HEADER_GENRULE}
%{TF_SHARED_LIBRARY_GENRULE}
