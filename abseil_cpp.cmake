# Copyright 2018 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
if (systemlib_ABSEIL_CPP)

  find_package(AbseilCpp REQUIRED
               absl_base
               absl_spinlock_wait
               absl_dynamic_annotations
               absl_malloc_internal
               absl_throw_delegate
               absl_int128
               absl_strings
               str_format_internal
               absl_bad_optional_access)

  include_directories(${ABSEIL_CPP_INCLUDE_DIR})
  list(APPEND tensorflow_EXTERNAL_LIBRARIES ${ABSEIL_CPP_LIBRARIES})

  message(STATUS "  abseil_cpp includes: ${ABSEIL_CPP_INCLUDE_DIR}")
  message(STATUS "  abseil_cpp libraries: ${ABSEIL_CPP_LIBRARIES}")

  add_custom_target(abseil_cpp)
  list(APPEND tensorflow_EXTERNAL_DEPENDENCIES abseil_cpp)

else (systemlib_ABSEIL_CPP)

  include (ExternalProject)

  set(abseil_cpp_INCLUDE_DIR ${CMAKE_BINARY_DIR}/abseil_cpp/src/abseil_cpp)
  set(abseil_cpp_URL https://github.com/abseil/abseil-cpp/archive/df3ea785d8c30a9503321a3d35ee7d35808f190d.tar.gz)
  set(abseil_cpp_HASH SHA256=f368a8476f4e2e0eccf8a7318b98dafbe30b2600f4e3cf52636e5eb145aba06a)
  set(abseil_cpp_BUILD ${CMAKE_BINARY_DIR}/abseil_cpp/src/abseil_cpp-build)

  if(WIN32)
    if(${CMAKE_GENERATOR} MATCHES "Visual Studio.*")
      set(abseil_cpp_STATIC_LIBRARIES
          ${abseil_cpp_BUILD}/absl/base/Release/absl_log_severity.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_raw_logging_internal.lib
          ${abseil_cpp_BUILD}/absl/types/Release/absl_bad_any_cast_impl.lib
          ${abseil_cpp_BUILD}/absl/types/Release/absl_bad_optional_access.lib
          ${abseil_cpp_BUILD}/absl/types/Release/absl_bad_variant_access.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_dynamic_annotations.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_spinlock_wait.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_base.lib
          ${abseil_cpp_BUILD}/absl/hash/Release/absl_city.lib
          ${abseil_cpp_BUILD}/absl/time/Release/absl_civil_time.lib
          ${abseil_cpp_BUILD}/absl/strings/Release/absl_strings_internal.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_throw_delegate.lib
          ${abseil_cpp_BUILD}/absl/strings/Release/absl_cord.lib
          ${abseil_cpp_BUILD}/absl/debugging/Release/absl_debugging_internal.lib
          ${abseil_cpp_BUILD}/absl/debugging/Release/absl_demangle_internal.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_malloc_internal.lib
          ${abseil_cpp_BUILD}/absl/debugging/Release/absl_stacktrace.lib
          ${abseil_cpp_BUILD}/absl/debugging/Release/absl_symbolize.lib
          ${abseil_cpp_BUILD}/absl/debugging/Release/absl_examine_stack.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_exponential_biased.lib
          ${abseil_cpp_BUILD}/absl/debugging/Release/absl_failure_signal_handler.lib
          ${abseil_cpp_BUILD}/absl/synchronization/Release/absl_graphcycles_internal.lib
          ${abseil_cpp_BUILD}/absl/numeric/Release/absl_int128.lib
          ${abseil_cpp_BUILD}/absl/strings/Release/absl_strings.lib
          ${abseil_cpp_BUILD}/absl/time/Release/absl_time_zone.lib
          ${abseil_cpp_BUILD}/absl/time/Release/absl_time.lib
          ${abseil_cpp_BUILD}/absl/synchronization/Release/absl_synchronization.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags_program_name.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags_config.lib
          ${abseil_cpp_BUILD}/absl/strings/Release/absl_str_format_internal.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags_marshalling.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags_registry.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags_internal.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags_usage_internal.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags_usage.lib
          ${abseil_cpp_BUILD}/absl/flags/Release/absl_flags_parse.lib
          ${abseil_cpp_BUILD}/absl/hash/Release/absl_hash.lib
          ${abseil_cpp_BUILD}/absl/container/Release/absl_hashtablez_sampler.lib
          ${abseil_cpp_BUILD}/absl/debugging/Release/absl_leak_check.lib
          ${abseil_cpp_BUILD}/absl/debugging/Release/absl_leak_check_disable.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_periodic_sampler.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_distributions.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_internal_distribution_test_util.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_internal_randen_hwaes_impl.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_internal_randen_hwaes.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_internal_randen_slow.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_internal_randen.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_internal_seed_material.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_seed_gen_exception.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_internal_pool_urbg.lib
          ${abseil_cpp_BUILD}/absl/random/Release/absl_random_seed_sequences.lib
          ${abseil_cpp_BUILD}/absl/container/Release/absl_raw_hash_set.lib
          ${abseil_cpp_BUILD}/absl/base/Release/absl_scoped_set_env.lib
          ${abseil_cpp_BUILD}/absl/status/Release/absl_status.lib)
    else()
      set(abseil_cpp_STATIC_LIBRARIES
          ${abseil_cpp_BUILD}/absl/base/absl_base.lib
          ${abseil_cpp_BUILD}/absl/base/absl_spinlock_wait.lib
          ${abseil_cpp_BUILD}/absl/base/absl_dynamic_annotations.lib
          ${abseil_cpp_BUILD}/absl/base/absl_internal_malloc_internal.lib
          ${abseil_cpp_BUILD}/absl/base/absl_throw_delegate.lib
          ${abseil_cpp_BUILD}/absl/numeric/absl_int128.lib
          ${abseil_cpp_BUILD}/absl/strings/absl_strings.lib
          ${abseil_cpp_BUILD}/absl/strings/str_format_internal.lib
          ${abseil_cpp_BUILD}/absl/types/absl_bad_optional_access.lib)
    endif()
  else()
    set(abseil_cpp_STATIC_LIBRARIES
        ${abseil_cpp_BUILD}/absl/base/libabsl_base.a
        ${abseil_cpp_BUILD}/absl/base/libabsl_spinlock_wait.a
        ${abseil_cpp_BUILD}/absl/base/libabsl_dynamic_annotations.a
        ${abseil_cpp_BUILD}/absl/base/libabsl_malloc_internal.a
        ${abseil_cpp_BUILD}/absl/base/libabsl_throw_delegate.a
        ${abseil_cpp_BUILD}/absl/numeric/libabsl_int128.a
        ${abseil_cpp_BUILD}/absl/strings/libabsl_strings.a
        ${abseil_cpp_BUILD}/absl/strings/libstr_format_internal.a
        ${abseil_cpp_BUILD}/absl/types/libabsl_bad_optional_access.a)
  endif()

  ExternalProject_Add(abseil_cpp
      PREFIX abseil_cpp
      URL ${abseil_cpp_URL}
      URL_HASH ${abseil_cpp_HASH}
      DOWNLOAD_DIR "${DOWNLOAD_LOCATION}"
      BUILD_BYPRODUCTS ${abseil_cpp_STATIC_LIBRARIES}
      INSTALL_COMMAND ""
      CMAKE_CACHE_ARGS
          -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=${tensorflow_ENABLE_POSITION_INDEPENDENT_CODE}
          -DCMAKE_BUILD_TYPE:STRING=Release
          -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
  )

  include_directories(${abseil_cpp_INCLUDE_DIR})
  list(APPEND tensorflow_EXTERNAL_LIBRARIES ${abseil_cpp_STATIC_LIBRARIES})

  list(APPEND tensorflow_EXTERNAL_DEPENDENCIES abseil_cpp)

endif (systemlib_ABSEIL_CPP)