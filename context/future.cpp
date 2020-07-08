#include <iostream>
// #include <future>         // std::async, std::future
#include <cmath>
#include <functional>
#include <tuple>

// #include <bits/exception_ptr.h>
#include <boost/fiber/future/packaged_task.hpp>

#define VERSION_NAME_MAXLEN 64
typedef struct hiMPP_VERSION_S {
    char aVersion[VERSION_NAME_MAXLEN];
} MPP_VERSION_S;
extern "C" int HI_MPI_SYS_GetVersion(MPP_VERSION_S* pstVersion);

int calculate_the_answer_to_life_the_universe_and_everything() {
    return 42;
}

int main() {
    // HISI SDK example
    {
        MPP_VERSION_S version;
        HI_MPI_SYS_GetVersion(&version);
        std::cout << "MPP version: " << version.aVersion << std::endl;
    }

    // std::tuple example
    {
        std::tuple<int, int> t = std::tuple<int, int>{37, -73};
        std::cout << "tuple " << std::get<0>(t) << " " << std::get<1>(t) << std::endl;
    }

    // boost::future example
    {
        boost::fibers::packaged_task<int()> pt(calculate_the_answer_to_life_the_universe_and_everything);
        boost::fibers::future<int> fi=pt.get_future();
        boost::fibers::fiber(std::move(pt)).detach(); // launch task on a fiber
        fi.wait(); // wait for it to finish
    }

    // std::future example
    {
        std::cout << "1" << std::endl;
        std::packaged_task<int(int,int)> task([](int a, int b) {
            return std::pow(a, b); 
        });
        std::cout << "2" << std::endl;
        std::future<int> result = task.get_future();
        std::cout << "3" << std::endl;
        task(2, 9);
        std::cout << "4" << std::endl;
        std::cout << "task_lambda: " << result.get() << std::endl;
    }
    return 0;
}

#if UINT32_MAX == UINTPTR_MAX
#define STACK_CHK_GUARD 0xe2dee396
#else
#define STACK_CHK_GUARD 0x595e9fbd94fda766
#endif

uintptr_t __stack_chk_guard = STACK_CHK_GUARD;

__attribute__((noreturn))
void __stack_chk_fail(void)
{
#if __STDC_HOSTED__
	abort();
#elif __is_myos_kernel
	panic("Stack smashing detected");
#endif
}
