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

void use(ggml_gallocr_t graph) { }

void alsoBad() {
  unsigned int order = 0;
  for (int i = 0; i < 8; ++i) {
    ggml_gallocr_t graph = ggml_gallocr_new(0);
    use(graph);
    // `graph` leaks here in each iteration.
    order++;
  }
}

ggml_gallocr_t good() {
  ggml_gallocr_t graph = ggml_gallocr_new(0);
  return graph;
}

int alsoGood() {
  ggml_gallocr_t graph = ggml_gallocr_new(0);
  if (!graph) {
    // `graph is `NULL` and does not leak here.
    return -1;
  }
  use(graph);
  
  ggml_gallocr_free(graph);
  return 0;
}

int main(int argc, char** argv) {
  int flag = 0;
  
  ggml_gallocr_t graph = good();
  alsoGood();
  
  bad(flag);
  alsoBad();

  if (condition(flag)) {
    ggml_gallocr_free(graph);
  } else {
    ggml_gallocr_free(graph);
  }


  return 0;
}
