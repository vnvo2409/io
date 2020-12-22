licenses(["notice"])  # Apache 2.0

package(default_visibility = ["//visibility:public"])

load(
    "//:tools/build/tensorflow_io.bzl",
    "tf_io_copts",
)

cc_library(
    name = "s3",
    srcs = [
        "aws_crypto.cc",
        "aws_crypto.h",
        "aws_logging.cc",
        "aws_logging.h",
        "s3_filesystem.cc",
        "s3_filesystem.h",
    ],
    copts = tf_io_copts() + select({
        "@bazel_tools//src/conditions:windows": [],
        "//conditions:default": [
            "-fvisibility=hidden",
            "-Wl,--exclude-libs=ALL",
        ],
    }),
    linkstatic = True,
    deps = [
        "//tensorflow_io/core/plugins:plugins_header",
        "@aws-sdk-cpp",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/synchronization",
    ],
    alwayslink = 1,
)
