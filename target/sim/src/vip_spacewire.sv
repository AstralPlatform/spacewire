// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Collects all existing verification IP (VIP) in one module for use in testbenches of
// WpaceWire and other systems that use it. IOs are of inout direction where applicable.

module vip_spacewire import spacewire_pkg::*; #(
  parameter int unsigned AxiAddrWidth = '0,
  parameter int unsigned AxiDataWidth = '0
)(
  output logic clk,
  output logic rst_n
);

endmodule: vip_spacewire
