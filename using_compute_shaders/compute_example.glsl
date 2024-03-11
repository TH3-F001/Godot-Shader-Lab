#[compute]
#version 450

layout(local_size_x = 2, local_size_y = 1, local_size_z = 1) in;

layout(set = 0, binding = 0, std430) restrict buffer MyDataBuffer {
    float data[];
}
my_data_buffer;

uint factorial(uint n) {
    if (n == 0u) return 1u;
    uint result = 1u;
    for (uint i = 1u; i <= n; ++i) {
        result *= i;
    }
    return result;
}

void main() {
    uint index = gl_GlobalInvocationID.x;
    uint value = uint(my_data_buffer.data[index]); // Assuming the data can be treated as an unsigned integer
    uint factValue = factorial(value);
    my_data_buffer.data[index] = float(factValue); // Storing the result back as float, be wary of potential overflow
}