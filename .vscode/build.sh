BAZEL_DISK_CACHE_TF_IO=$BAZEL_DISK_CACHE_ROOT_DIR/tf_io/
BAZEL_REPOSITORY_CACHE_TF_IO=$BAZEL_REPOSITORY_CACHE_ROOT_DIR/tf_io/
PROJECT_ROOT=$PWD
set -e

# 

common () {
    bazelisk "$1" \
    --disk_cache=$BAZEL_DISK_CACHE_TF_IO --repository_cache=$BAZEL_REPOSITORY_CACHE_TF_IO \
    --cache_test_results=no \
    --copt=-msse4.2 --copt=-mavx --compilation_mode=opt "${@:2}"
}

if [[ $1 == "t" ]]; then
    common test "${@:2}"
elif [[ $1 == "b" ]]; then
    common build "${@:2}"
elif [[ $1 == "io" ]]; then
    common build "//tensorflow_io/core:python/ops/libtensorflow_io.so" "${@:2}"
elif [[ $1 == "plugins" ]]; then
    common build "//tensorflow_io/core:python/ops/libtensorflow_io_plugins.so" "${@:2}"
    common build "//tensorflow_io_plugin_gs/core:python/ops/libtensorflow_io_plugin_gs.so" "${@:2}"
elif [[ $1 == "pytest" ]]; then
    source $P_DIR/.venvs/tf-io/bin/activate
    export TF_USE_MODULAR_FILESYSTEM=1
    export TF_AZURE_USE_DEV_STORAGE=1
    TFIO_DATAPATH=bazel-bin python3 -m pytest tests/test_$2.py "${@:3}" -W ignore::DeprecationWarning --capture=no
elif [[ $1 == "pytest-vscode" ]]; then
    python3 -m pytest .vscode/$2.py "${@:3}" -W ignore::DeprecationWarning
elif [[ $1 = "style-cc" ]]; then
    git diff --name-only | grep -E "(.h|.cc)" | xargs clang-format --style=google -i
elif [[ $1 == "env" ]]; then
    export TFIO_DATAPATH=$(bazel info bazel-bin -c opt)
    echo $TFIO_DATAPATH
elif [[ $1 == "lint" ]]; then
    ARCHFLAGS="-arch x86_64" common run "//tools/lint:lint"
elif [[ $1 == "emu" ]]; then
    source $P_DIR/.venvs/tf-io/bin/activate
    gunicorn --bind "0.0.0.0:9099" --worker-class gevent --chdir "tests/test_gcloud/testbench" testbench:application --access-logfile -
elif [[ $1 == "az" ]]; then
    cd .vscode/
    export TF_AZURE_USE_DEV_STORAGE=1
    $(npm bin)/azurite-blob
elif [[ $1 == "s3" ]]; then
    DEBUG=1 SERVICES=s3 localstack start
fi

# export AWS_REGION=us-east-1
# export AWS_ACCESS_KEY_ID=ACCESS_KEY
# export AWS_SECRET_ACCESS_KEY=SECRET_KEY
# export S3_ENDPOINT=localhost:4566
# export S3_USE_HTTPS=0
# export S3_VERIFY_SSL=0

# tf.experimental.register_filesystem_plugin("/private/var/tmp/_bazel_vovannghia/d73cdf28b8a1fb24b5dca30beefcb683/execroot/org_tensorflow_io/bazel-out/darwin-opt/bin/tensorflow_io/core/python/ops/libtensorflow_io_plugins.so")
# tf.io.read_file("s3e://vnvo/test.log")
# run ~/programming/main.py
