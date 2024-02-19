module MAC_Pipelined (
  input logic signed [31:0] vector_A [15:0],
  input logic signed [31:0] vector_B [15:0],
  output logic signed [63:0] result,
  input logic clk, // Clock input
  input logic rst  // Reset input
);

  // Internal registers to hold intermediate multiplication results and the accumulator
  logic signed [31:0] multiply_results [15:0];
  logic signed [63:0] acc;

  // Pipeline stages
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset pipeline registers on reset
      multiply_results <= '0;
      acc <= '0;
    end else begin
      // Stage 1: Multiply each element
      for (int i = 0; i < 16; i = i + 1) begin
        multiply_results[i] <= vector_A[i] * vector_B[i];
      end
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset accumulator on reset
      acc <= '0;
    end else begin
      // Stage 2: Accumulate first set of results
      acc <= multiply_results[0];
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset multiplication results on reset
      multiply_results <= '0;
    end else begin
      // Stage 3: Accumulate second set of results
      acc <= acc + multiply_results[1];
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset multiplication results on reset
      multiply_results <= '0;
    end else begin
      // Stage 4: Accumulate third set of results
      acc <= acc + multiply_results[2];
    end
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset multiplication results on reset
      multiply_results <= '0;
    end else begin
      // Stage 5: Accumulate remaining results
      for (int i = 3; i < 16; i = i + 1) begin
        acc <= acc + multiply_results[i];
      end
    end
  end

  // Output the final result
  assign result = acc;

endmodule
