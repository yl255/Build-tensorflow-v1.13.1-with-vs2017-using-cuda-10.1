# tensorflow-v1.31.1-build-with-vs2017-cuda10.1

system info: cuda 10.1, vs2017 Community, cmake 3.16.0
I just build the C/C++ api, not using Python.
### prepare for building:
#### 1.1 tensorflow-v1.31.1 source code (please download from github)
+ 1) unzip the code to ./tensorflow-1.13.1
+ 2) the project need a new version of abseil_cpp. Update the abseil_cpp.cmake (in the ./tensorflow/contrib/cmake/external) to  the my version.
+ 3) copy the "version_info.cc" file to the ./tensorflow/core/util/version_info.cc.(Auto generate?)
+ 4) open the file "/tensorflow/core/util/cuda_kernel_helper.h", 
   change #include "cuda/include/cuda_fp16.h" to #include "cuda_fp16.h"
   see: [issues31349](https://github.com/tensorflow/tensorflow/issues/31349 "issues31349")
+ 5) update the tf_core_kernels.cmake (in the ./tensorflow/contrib/cmake/external)
Just add nccl_manager files. I failed to add a new 'tf_core_nccl.cmake' file to the project :(.
+ 6) about the inculd 'cud' libraray.
There are some source files with the header like [#include "third_party/cub/*.cuh"]
It maybe need to change: #include "cub/*.cuh", delete the 'third_party/'
The files such as:
`tensorflow/core/kernels/scan_ops_gpu.cu.cc`
`tensorflow/core/kernels/depthwise_conv_op_gpu.cu.cc`
`tensorflow/core/kernels/dynamic_partition_op_gpu.cu.cc`
`tensorflow/core/kernels/histogram_op_gpu.cu.cc`
`tensorflow/core/kernels/topk_op_gpu.cu.cc`
`tensorflow/core/kernels/where_op_gpu.cu.h`
`tensorflow/core/kernels/bincount_op_gpu.cu.cc'
+ 7) !!!open the file 'tensorflow/core/framework/op_kernel.h',
change [reference operator*() { return (*list_)[i_]; }] to 
       reference operator*() const { return (*list_)[i_]; }
see:[25943](https://github.com/tensorflow/tensorflow/pull/25943 "25943")
+ 8)about 'grpc'.
The CMakeList.txt has the item 'tensorflow_ENABLE_GRPC_SUPPORT', but it seemed can not build succesed with 'tensorflow_ENABLE_GRPC_SUPPORT=OFF'.So I build the project with 'tensorflow_ENABLE_GRPC_SUPPORT=ON'.
And the grpc version is 1.24.3.
It need to edit the file grpc.cmake(in tensorflow/contrib/cmake/external) , but I do not know the new GRPC_TAG value.
So I just copy the code of grpc-v1.24.3 to the folder.
when building, there are some forward declaration errors about the 'grpc':
some header files with the forward declaration like:
		namespace grpc {
			class CompletionQueue;
			class Channel;
			class RpcService;
			class ServerCompletionQueue;
			class ServerContext;
		}  // namespace grpc'
I just comment out the redefined class such as "class CompletionQueue", and add the header file #include "grpcpp/completion_queue.h".
**!!!It is very strange :(**
The files as follows(maybe more):
tensorflow/core/distributed_runtime/rpc/eager/grpc_eager_service.h
tensorflow/core/distributed_runtime/rpc/grpc_worker_service.h
+ 9)use the **proto.exe**(see below 1.2) for the tf_stream_executor.
 Maybe it should be auto done with the file tf_stream_executor.cmake as the file tf_core_framework.cmake(in tensorflow/contrib/cmake).
But I was failed, so I do it myself.
We need to use the proto.exe to generate the dnn.pb.h and dnn.pb.cc with dnn.proto which is in tensorflow/stream_executor.
The command like:
`.\protoc.exe --cpp_out=.\build2017\tensorflow\stream_executor --proto_path=.\tensorflow\stream_executor dnn.proto`
The files dnn.pb.h and dnn.pb.cc will be used later.
+ 10)about protobuf.cmake (in tensorflow/contrib/cmake/external), maybe it need to be reedit for CMake can get the right version of  protobuf 3.6.1.

#### 1.2 protobuf-v3.6.1 source code (please download from github)
+ 1) unzip the code to ./protobuf
+ 2) use the CMake to build the protobuf with vs2017 x64
+ 3) when builded succesed, there is 'protoc.exe' file, it will be used later.

#### 1.3 nccl for windows.
see: [nccl for windows](https://github.com/MyCaffe/NCCL)
+ 1) unzip the code to ./nccl, and open the project which is ./nccl/windows/nccl.sln with vs2017.
+ 2) build the 'nccl.10.1' static lib, using Release X64.
when build succesed, will get dirtorys: ./nccl/windows/x64/Release and ./nccl/windows/x64/Release/obj.10.1.
the *.lib and the *.obj files in the folders will be used later.

#### 1.4 icu v62.1 source code
[icu-v62.1 source code](https://github.com/unicode-org/icu/archive/release-62-1.tar.gz)
[How to build icu](http://userguide.icu-project.org/icufaq)
Atfer building, you can get the include dirtory which is './icu/include' and the lib directory which is './icu/lib64'.

### 2 first build the vs project with cmake.
I use the cmake-gui(v3.16.0) for generate the project.
#### 2.1 The source code directory is: ./tensorflow/contrib/cmake
The build directory is : ./build2017
#### 2.2 chose the vs2017 and X64 for generate the project.
#### 2.3 set as follows:
`tensorflow_ENABLE_GRPC_SUPPORT=ON`
`tensorflow_ENABLE_GPU=ON`
`tensorflow_BUILD_PYTHON_BINDINGS=OFF`
`CUDA_TOOLKIT_ROOT_DIR=C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v10.1`
`tensorflow_BUILD_SHARED_LIB=ON` (for build the tensorflow.dll)
 The SWIG is not need to set when tensorflow_BUILD_PYTHON_BINDINGS=OFF.
####2.4 when generated done, open the project (I got 196 sub projects).
####2.5 manually editing the project.
+ 1) copy add dnn.pb.h and dnn.pb.cc (see 1.1.9) to the directory ./build2017/tensorflow/stream_executor. And add them to tf_stream_executor project for building.
+ 2) copy the icu to the project dirtory ./build2017. you need to build it(see 1.4)
+ 3) copy the grpc(version 1.24.3) source code to the folder ./build2017/grpc/src/grpc.
+ 4) copy the nccl code to the ./build2017/nccl folder. you need to build it(see 1.3)
     + Some file include **nccl.h**, need to reedit.
     + The files: tensorflow/core/kernels/nccl_ops.cc, tensorflow/core/nccl/nccl_manager.h 
	 change '```#include "third_party/nccl/nccl.h"``` to ```#include "nccl/nccl.h" ```.
**make sure the right folder of the nccl.h**

####2.6 add the icu/lib64/icuuc.lib to the tf_core_kernels project.
 How to do:
Right click tf_core_kernels project, chose Configuration Properties->Link->Input->Additional Dependencies.
The icu include folder is also needed to add to the project. .\build2017-s\icu\include
Right click tf_core_kernels project, chose Configuration Properties->C/C++->General->Additional Include Directories

####  2.7 build the program with 'Release X64' model.
####  2.8 When building, it maybe get an Error C1060: compiler is out of heap space
see:[error c1060](https://docs.microsoft.com/en-us/cpp/error-messages/compiler-errors-1/fatal-error-c1060?view=vs-2019 "error c1060")
 What I do:
 Reedit the *tf_core_kernels.vcxproj* file, find the text: 
 ```
 <Import Project="$(VCTargetsPath)\Microsoft.Cpp.Default.props" />
 ```
 under it, add:
 ```
<PropertyGroup>
<PreferredToolArchitecture>x64</PreferredToolArchitecture>
</PropertyGroup>
```
####2.9 Reload the project, and build it again.
###3 After first building, some tool projects will be failed, and the tensorflow.dll will be failed.
  such as **grpc_tensorflow_server**, **benchmark_model**, **transform_graph**, **compare_graphs**, **summarize_graph**
  There are some *.obj and *.lib files:
+ dnn.pb.h.obj (in ./build2017/tf_stream_executor.dir/Release)
+ core.cu.obj, all_reduce.cu.obj, broadcast.cu.obj, reduce.cu.obj (in nccl/windows/x64/Release/obj.10.1, see 1.3)
+ nccl64_134.10.1.lib (in nccl/windows/x64/Release)
+ icuuc.lib (in icu\lib64, see 1.4)
####3.1 grpc_tensorflow_server:
+ add dnn.pb.h.obj to the project's **[Object Libraries]**.
**  !!!Expand the project in the solution view, the 'Object Libraries' option will be seen. **
+ add tf_core_eager_runtime.dir\Release\tf_core_eager_runtime.lib to the project.
+ add cares.lib(in the folder ./build2017/grpc/src/grpc/third_party/cares/cares/lib/Release) to the project.
+ add nccl64_134.10.1.lib to the project
+ grpc\src\grpc\$(Configuration)\address_sorting.lib to the project
####3.2 benchmark_model
+ add tf_cc_ops.dir\Release\tf_cc_ops.lib to the project.
+ add icuuc.lib to the project.
+ add core.cu.obj, all_reduce.cu.obj, broadcast.cu.obj, reduce.cu.obj to the project's [Object Libraries].
+ tf_cc_framework.dir\Release ops.obj scope.obj to the project's [Object Libraries].
+ add nccl64_134.10.1.lib(see 1.3) to the project.
####3.3 transform_graph
+ add dnn.pb.h.obj to the project's [Object Libraries].
+ add icuuc.lib to the project.
+ tf_cc_framework.dir\Release\tf_cc_framework.lib to the project.
+ tf_cc_ops.dir\Release\tf_cc_ops.lib to the project.
+ add core.cu.obj, all_reduce.cu.obj, broadcast.cu.obj, reduce.cu.obj to the project's [Object Libraries].
+ add nccl64_134.10.1.lib(see 1.3) to the project.
####3.4 compare_graphs
+ add icuuc.lib to the project.
+ add tf_stream_executor.dir\Release\tf_stream_executor.lib to the project.
+ add tf_cc_framework.dir\Release\tf_cc_framework.lib to the project.
+ add tf_cc_ops.dir\Release\tf_cc_ops.lib to the project.
+ add core.cu.obj, all_reduce.cu.obj, broadcast.cu.obj, reduce.cu.obj to the project's [Object Libraries].
+ add nccl64_134.10.1.lib to the project.
####3.5 summarize_graph
+ add icuuc.lib to the project.
+ tf_stream_executor.dir\Release\tf_stream_executor.lib, tf_cc_ops.dir\Release\tf_cc_ops.lib,  tf_cc_framework.dir\Release\tf_cc_framework.lib to the project.
+ add nccl64_134.10.1.lib to the project.
+ add core.cu.obj, all_reduce.cu.obj, broadcast.cu.obj, reduce.cu.obj to the project's [Object Libraries].
####3.6 about the tensorflow.dll
+ add grpc\src\grpc\$(Configuration)\address_sorting.lib to the project
+ add icuuc.lib to the project
+ add dnn.pb.h.obj to the project
+ add nccl64_134.10.1.lib to the project
+ add core.cu.obj, all_reduce.cu.obj, broadcast.cu.obj, reduce.cu.obj to the project
+ **delete** one of the *c_api.cc.obj* files in the project's [Object Libraries].
+ **delete** one of the *c_api_debug.obj* files in the project's [Object Libraries].
####3.7 Then rebuild the project.
###4 Install the project.
  build the INSTALL project to get the header files and libs.
###5 to do list
  some steps should be done in cmake file.