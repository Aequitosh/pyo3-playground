#define PY_SSIZE_T_CLEAN
#include "Python.h"
// Implies <stdio.h>, <string.h>, <errno.h>, <limits.h>, <assert.h> and
// <stdlib.h>

#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <string>


void print_python_info() {
  std::cout << "Python Interpreter Information:\n";
  std::wcout << '\t' << std::wstring(Py_GetProgramName()) << '\n'
             << '\t' << std::wstring(Py_GetPrefix()) << '\n'
             << '\t' << std::wstring(Py_GetExecPrefix()) << '\n'
             << '\t' << std::wstring(Py_GetProgramFullPath()) << '\n'
             << '\t' << std::wstring(Py_GetPath()) << '\n';

  std::cout << '\t' << std::string(Py_GetVersion()) << '\n'
            << '\t' << std::string(Py_GetPlatform()) << '\n';

  std::flush(std::cout);
}

int main(int argc, char *argv[]) {
  std::cout << "Executed via:";
  for (int i{0}; i < argc; ++i) {
    std::cout << ' ' << argv[i];
  }
  std::cout << std::endl;

  wchar_t *program = Py_DecodeLocale(argv[0], nullptr);
  if (program == nullptr) {
    std::cerr << "Fatal: Cannot decode argv[0]\n";
    std::exit(1);
  }

  Py_Initialize();

  print_python_info();

  // Swapping between thread states
  PyGILState_STATE gil_state = PyGILState_Ensure();

  PyThreadState *main_thread_state = PyThreadState_Get();

  PyThreadState *sub_int_state_1 = Py_NewInterpreter();
  PyThreadState *sub_int_state_2 = Py_NewInterpreter();

  std::cout << "main_thread_state = " << main_thread_state << "\n"
            << "sub_int_state_1 = " << sub_int_state_1 << "\n"
            << "sub_int_state_2 = " << sub_int_state_2 << "\n";

  // Current thread state should now be equal to sub_int_state_2
  PyThreadState *current_state = PyThreadState_Get();
  std::cout << "sub_int_state_2 == current_state = " << (sub_int_state_2 == current_state) << '\n';

  // Swap back to the original thread state
  PyThreadState *swapped_state = PyThreadState_Swap(main_thread_state);
  std::cout << "swapped_state = " << swapped_state << '\n';
  std::cout << "swapped_state == sub_int_state_2 = " << (swapped_state == sub_int_state_2) << '\n';

  // Destroy the sub-interpreters before releasing the GIL
  // Swap into interpreter to end first, and then actually end it
  // --> PyThreadState to destroy must be current thread, basically
  PyThreadState *state = PyThreadState_Swap(sub_int_state_1);
  std::cout << "state = " << state << '\n';
  Py_EndInterpreter(sub_int_state_1);

  // Same thing here
  state = PyThreadState_Swap(sub_int_state_2);
  std::cout << "state = " << state << '\n';
  Py_EndInterpreter(sub_int_state_2);

  PyThreadState *should_be_nullptr = PyThreadState_Swap(main_thread_state);
  std::cout << "should_be_nullptr = " << should_be_nullptr << '\n';

  PyGILState_Release(gil_state);

  std::cout << "Running example program:\n";
  const char *py_test_prog = "import playground\n"
    "print(playground.hello_world())\n";

  PyRun_SimpleString(py_test_prog);

  std::cout << "\nFinalizing and freeing remaining memory\n";

  if (Py_FinalizeEx() < 0) {
    std::cerr << "Py_FinalizeEx returned status < 0\n";
    std::exit(2);
  }

  PyMem_RawFree(program);
  return 0;
}
