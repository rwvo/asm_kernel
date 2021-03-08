	.text
	.amdgcn_target "amdgcn-amd-amdhsa--gfx906"
	.protected	kernel            ; -- Begin function kernel
	.globl	kernel
	.p2align	8
	.type	kernel,@function
kernel:                           ; @kernel
; %bb.0:                                ; %entry
	s_load_dword s0, s[6:7], 0x8
; %bb.1:                                ; %if.then
	s_load_dwordx2 s[0:1], s[6:7], 0x0
	v_mov_b32_e32 v2, 0
	v_lshlrev_b32 v1, 2, v0
	s_waitcnt lgkmcnt(0)
	v_mov_b32_e32 v2, s1
	v_add_co_u32_e32 v1, vcc, s0, v1
	s_mov_b32 s0, 0xaaaaaaaa
	s_mov_b32 s1, 0xaaaaaaaa
	s_mov_b64 exec, s[0:1]
	v_mov_b32_e32 v0, 666
	s_mov_b32 s0, 0xffffffff
	s_mov_b32 s1, 0xffffffff
	s_mov_b64 exec, s[0:1]
	global_store_dword v[1:2], v0, off
BB0_2:                                  ; %if.end
	s_endpgm
	.section	.rodata,#alloc
	.p2align	6
	.amdhsa_kernel kernel
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_user_sgpr_private_segment_buffer 1
		.amdhsa_user_sgpr_dispatch_ptr 1
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_flat_scratch_init 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_system_sgpr_private_segment_wavefront_offset 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 0
		.amdhsa_system_sgpr_workgroup_id_z 0
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 4
		.amdhsa_next_free_sgpr 9
		.amdhsa_reserve_flat_scratch 0
		.amdhsa_reserve_xnack_mask 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text
.Lfunc_end0:
	.size	kernel, .Lfunc_end0-kernel
                                        ; -- End function
	.amdgpu_metadata
---
amdhsa.kernels:
  - .args:
      - .address_space:  global
        .name:           args.coerce
        .offset:         0
        .size:           8
        .value_kind:     global_buffer
      - .name:           size
        .offset:         8
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 12
    .max_flat_workgroup_size: 1024
    .name:           kernel
    .private_segment_fixed_size: 0
    .sgpr_count:     11
    .symbol:         kernel.kd
    .vgpr_count:     4
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx906
amdhsa.version:
  - 1
  - 1
...
	.end_amdgpu_metadata
