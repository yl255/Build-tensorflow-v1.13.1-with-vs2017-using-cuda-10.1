1.abseil_cpp.cmake

2.\tensorflow\core\util\cuda_kernel_helper.h 
   #include "cuda/include/cuda_fp16.h" => #include "cuda_fp16.h"
   
3..\tensorflow\core\util\version_info.cc 添加

4.
 F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\reduction_gpu_kernels.cu.h
 修改
 //#include "third_party/cub/device/device_reduce.cuh"
//#include "third_party/cub/device/device_segmented_reduce.cuh"
//#include "third_party/cub/iterator/counting_input_iterator.cuh"
//#include "third_party/cub/iterator/transform_input_iterator.cuh"
//#include "third_party/cub/warp/warp_reduce.cuh"

#include "cub/device/device_reduce.cuh"
#include "cub/device/device_segmented_reduce.cuh"
#include "cub/iterator/counting_input_iterator.cuh"
#include "cub/iterator/transform_input_iterator.cuh"
#include "cub/warp/warp_reduce.cuh"

5.nccl
https://github.com/MyCaffe/NCCL
F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\nccl_ops.cc
#include "third_party/nccl/nccl.h"
 => #include "nccl/nccl.h"

F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\nccl\nccl_manager.h
#include "third_party/nccl/nccl.h"
 => #include "nccl/nccl.h"

6.icu
https://github.com/unicode-org/icu/archive/release-62-1.tar.gz

7.F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\distributed_runtime\rpc\grpc_worker_service.h
//class ServerBuilder;//注释掉此定义

8.tensorflow/core/framework/op_kernel.h 
  - reference operator*() { return (*list_)[i_]; }
  + reference operator*() const { return (*list_)[i_]; }

9.F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\distributed_runtime\rpc\eager\grpc_eager_service.h
+ #include "grpcpp/impl/codegen/client_context.h"
+ #include "grpcpp/impl/codegen/server_context.h"

+ #include "grpcpp/impl/codegen/completion_queue.h"
namespace grpc {

//class CompletionQueue;

class Channel;

class RpcService;

//class ServerCompletionQueue;

//class ServerContext;

}  // namespace grpc

10. grpc 1.24.3
namespace grpc {

class ByteBuffer;

//class ServerBuilder;

}  // namespace grpc

11.F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\bincount_op_gpu.cu.cc
- #include "third_party/cub/device/device_histogram.cuh"

+ #include "cub/device/device_histogram.cuh"

F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\depthwise_conv_op_gpu.cu.cc
//#include "third_party/cub/util_ptx.cuh"
#include "cub/util_ptx.cuh"

F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\dynamic_partition_op_gpu.cu.cc
//#include "third_party/cub/device/device_radix_sort.cuh"

//#include "third_party/cub/device/device_reduce.cuh"

//#include "third_party/cub/iterator/constant_input_iterator.cuh"

//#include "third_party/cub/thread/thread_operators.cuh"

#include "cub/device/device_radix_sort.cuh"

#include "cub/device/device_reduce.cuh"

#include "cub/iterator/constant_input_iterator.cuh"

#include "cub/thread/thread_operators.cuh"

F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\histogram_op_gpu.cu.cc
//#include "third_party/cub/device/device_histogram.cuh"
#include "cub/device/device_histogram.cuh"

F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\scan_ops_gpu.cu.cc
//#include "third_party/cub/block/block_load.cuh"

//#include "third_party/cub/block/block_scan.cuh"

//#include "third_party/cub/block/block_store.cuh"

//#include "third_party/cub/iterator/counting_input_iterator.cuh"

//#include "third_party/cub/iterator/transform_input_iterator.cuh"

#include "cub/block/block_load.cuh"

#include "cub/block/block_scan.cuh"

#include "cub/block/block_store.cuh"

#include "cub/iterator/counting_input_iterator.cuh"

#include "cub/iterator/transform_input_iterator.cuh"


F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\topk_op_gpu.cu.cc
//#include "third_party/cub/device/device_segmented_radix_sort.cuh"

//#include "third_party/cub/iterator/counting_input_iterator.cuh"

//#include "third_party/cub/iterator/transform_input_iterator.cuh"

#include "cub/device/device_segmented_radix_sort.cuh"

#include "cub/iterator/counting_input_iterator.cuh"

#include "cub/iterator/transform_input_iterator.cuh"



F:\SELF\tensorflow-1.13.1\tensorflow-1.13.1\tensorflow\core\kernels\where_op_gpu.cu.h
//#include "third_party/cub/device/device_reduce.cuh"

//#include "third_party/cub/device/device_select.cuh"

//#include "third_party/cub/iterator/counting_input_iterator.cuh"

//#include "third_party/cub/iterator/transform_input_iterator.cuh"

#include "cub/device/device_reduce.cuh"

#include "cub/device/device_select.cuh"

#include "cub/iterator/counting_input_iterator.cuh"

#include "cub/iterator/transform_input_iterator.cuh"

11.summarize_graph 添加tf_cc_framework.dir\Release\tf_cc_framework.lib,
tf_cc_ops.dir\Release\tf_cc_ops.lib,
tf_core_kernels.dir\Release\tf_core_kernels.lib,
icu\lib64\icuuc.lib

12.transform_graph 添加 F:\SELF\tensorflow-1.13.1\build2017\icu\lib64\icuuc.lib

13. grpc_tensorflow_server 添加
 dnn.pb.h.obj
 icu\lib64\icuuc.lib
F:\SELF\tensorflow-1.13.1\build2017\nccl\windows\x64\Release\obj.10.1\core.cu.obj
F:\SELF\tensorflow-1.13.1\build2017\tf_core_eager_runtime.dir\Release\eager_executor.obj
F:\SELF\tensorflow-1.13.1\build2017\tf_core_eager_runtime.dir\Release\context.obj
F:\SELF\tensorflow-1.13.1\build2017\tf_core_eager_runtime.dir\Release\tensor_handle.obj
tf_core_eager_runtime.dir\Release\tf_core_eager_runtime.lib
F:\SELF\grpc-1.24.3-build2017\third_party\cares\cares\lib\Release\cares.lib

14.benchmark_model 
   tf_cc_ops.dir\Release\tf_cc_ops.lib

15.transform_graph
icu\lib64\icuuc.lib
tf_stream_executor.dir\Release\dnn.pb.obj
tf_cc_framework.dir\Release\tf_cc_framework.lib
tf_cc_ops.dir\Release\tf_cc_ops.lib
F:\SELF\tensorflow-1.13.1\build2017\nccl\windows\x64\Release\obj.10.1\*.obj

16.compare_graphs
icu\lib64\icuuc.lib
tf_stream_executor.dir\Release\tf_stream_executor.lib
F:\SELF\tensorflow-1.13.1\build2017\nccl\windows\x64\Release\obj.10.1
tf_cc_framework.dir\Release\tf_cc_framework.lib
tf_cc_ops.dir\Release\tf_cc_ops.lib

17. summarize_graph
icu\lib64\icuuc.lib
tf_stream_executor.dir\Release\tf_stream_executor.lib
nccl\lib\nccl64_134.10.1.lib
F:\SELF\tensorflow-1.13.1\build2017\nccl\windows\x64\Release\obj.10.1\*.obj
tf_cc_ops.dir\Release\tf_cc_ops.lib
tf_cc_framework.dir\Release\tf_cc_framework.lib
