#include "../../../include/ggml/ggml-alloc.h"

int condition(int flag) {
  return (flag == 1);
}

int bad(int flag) {
  ggml_gallocr_t graph = ggml_gallocr_new(0);

  if (condition(flag)) {
    // `graph` may leak here.
    return -1;
  }

  // `graph` is properly freed here.
  ggml_gallocr_free(graph);
  return 0;
}

ggml_gallocr_t good() {
  ggml_gallocr_t graph = ggml_gallocr_new(0);
  return graph;
}

int main(int argc, char** argv) {
  int flag = 0;
  
  ggml_gallocr_t graph = good();
  bad(flag);

  if (condition(flag)) {
    ggml_gallocr_free(graph);
  } else {
    ggml_gallocr_free(graph);
  }

  return 0;
}
