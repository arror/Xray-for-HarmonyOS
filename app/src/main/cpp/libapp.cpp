#include "libxray.h"
#include "napi/native_api.h"
#include <stdio.h>

static napi_value NAPI_RUN(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1];
    napi_get_cb_info(env, info, &argc, args, NULL, NULL);
    uint8_t *data;
    size_t length;
    napi_value buffer;
    size_t offset;
    napi_get_typedarray_info(env, args[0], nullptr, &length, (void **)&data, &buffer, &offset);
    napi_value res;
    napi_create_int32(
        env, 
        Run({.data = data, .len = static_cast<GoInt>(length), .cap = static_cast<GoInt>(length)}),
        &res
    );
    return res;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"run", nullptr, NAPI_RUN, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "app",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterAppModule(void) { napi_module_register(&demoModule); }
