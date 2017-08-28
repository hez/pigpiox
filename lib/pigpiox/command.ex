defmodule Pigpiox.Command do
  @moduledoc false

  @commands %{
    set_mode:               0,
    get_mode:               1,
    gpio_read:              3,
    gpio_write:             4,
    set_servo_pulsewidth:   8,
    notify_open:            18,
    notify_begin:           19,
    notify_pause:           20,
    notify_close:           21,
    get_servo_pulsewidth:   84,

    waveform_clear_all:     27,
    waveform_add_generic:   28,
    waveform_add_serial:    29,
    waveform_busy: 32,
    waveform_stop: 33,
    waveform_get_micros: 34,
    waveform_get_pulses: 35,
    waveform_get_cbs: 36,
    waveform_create: 49,
    waveform_delete: 50,
    waveform_transmit_once: 51,
    waveform_transmit_repeat: 52,
    waveform_chain: 93,
    waveform_transmit_mode: 100,
    waveform_current: 101
  }
  @command_names Map.keys(@commands)

  @spec code(atom) :: pos_integer
  def code(command) when command in @command_names do
    @commands[command]
  end

  @error_code_map %{
    -1   => :init_failed,
    -2   => :bad_user_gpio,
    -3   => :bad_gpio,
    -4   => :bad_mode,
    -5   => :bad_level,
    -6   => :bad_pud,
    -7   => :bad_pulsewidth,
    -8   => :bad_dutycycle,
    -9   => :bad_timer,
    -10  => :bad_ms,
    -11  => :bad_timetype,
    -12  => :bad_seconds,
    -13  => :bad_micros,
    -14  => :timer_failed,
    -15  => :bad_wdog_timeout,
    -16  => :no_alert_func,
    -17  => :bad_clk_periph,
    -18  => :bad_clk_source,
    -19  => :bad_clk_micros,
    -20  => :bad_buf_millis,
    -21  => :bad_dutyrange,
    -22  => :bad_signum,
    -23  => :bad_pathname,
    -24  => :no_handle,
    -25  => :bad_handle,
    -26  => :bad_if_flags,
    -27  => :bad_channel,
    -27  => :bad_prim_channel,
    -28  => :bad_socket_port,
    -29  => :bad_fifo_command,
    -30  => :bad_seco_channel,
    -31  => :not_initialised,
    -32  => :initialised,
    -33  => :bad_wave_mode,
    -34  => :bad_cfg_internal,
    -35  => :bad_wave_baud,
    -36  => :too_many_pulses,
    -37  => :too_many_chars,
    -38  => :not_serial_gpio,
    -39  => :bad_serial_struc,
    -40  => :bad_serial_buf,
    -41  => :not_permitted,
    -42  => :some_permitted,
    -43  => :bad_wvsc_commnd,
    -44  => :bad_wvsm_commnd,
    -45  => :bad_wvsp_commnd,
    -46  => :bad_pulselen,
    -47  => :bad_script,
    -48  => :bad_script_id,
    -49  => :bad_ser_offset,
    -50  => :gpio_in_use,
    -51  => :bad_serial_count,
    -52  => :bad_param_num,
    -53  => :dup_tag,
    -54  => :too_many_tags,
    -55  => :bad_script_cmd,
    -56  => :bad_var_num,
    -57  => :no_script_room,
    -58  => :no_memory,
    -59  => :sock_read_failed,
    -60  => :sock_writ_failed,
    -61  => :too_many_param,
    -62  => :script_not_ready,
    -63  => :bad_tag,
    -64  => :bad_mics_delay,
    -65  => :bad_mils_delay,
    -66  => :bad_wave_id,
    -67  => :too_many_cbs,
    -68  => :too_many_ool,
    -69  => :empty_waveform,
    -70  => :no_waveform_id,
    -71  => :i2c_open_failed,
    -72  => :ser_open_failed,
    -73  => :spi_open_failed,
    -74  => :bad_i2c_bus,
    -75  => :bad_i2c_addr,
    -76  => :bad_spi_channel,
    -77  => :bad_flags,
    -78  => :bad_spi_speed,
    -79  => :bad_ser_device,
    -80  => :bad_ser_speed,
    -81  => :bad_param,
    -82  => :i2c_write_failed,
    -83  => :i2c_read_failed,
    -84  => :bad_spi_count,
    -85  => :ser_write_failed,
    -86  => :ser_read_failed,
    -87  => :ser_read_no_data,
    -88  => :unknown_command,
    -89  => :spi_xfer_failed,
    -90  => :bad_pointer,
    -91  => :no_aux_spi,
    -92  => :not_pwm_gpio,
    -93  => :not_servo_gpio,
    -94  => :not_hclk_gpio,
    -95  => :not_hpwm_gpio,
    -96  => :bad_hpwm_freq,
    -97  => :bad_hpwm_duty,
    -98  => :bad_hclk_freq,
    -99  => :bad_hclk_pass,
    -100 => :hpwm_illegal,
    -101 => :bad_databits,
    -102 => :bad_stopbits,
    -103 => :msg_toobig,
    -104 => :bad_malloc_mode,
    -105 => :too_many_segs,
    -106 => :bad_i2c_seg,
    -107 => :bad_smbus_cmd,
    -108 => :not_i2c_gpio,
    -109 => :bad_i2c_wlen,
    -110 => :bad_i2c_rlen,
    -111 => :bad_i2c_cmd,
    -112 => :bad_i2c_baud,
    -113 => :chain_loop_cnt,
    -114 => :bad_chain_loop,
    -115 => :chain_counter,
    -116 => :bad_chain_cmd,
    -117 => :bad_chain_delay,
    -118 => :chain_nesting,
    -119 => :chain_too_big,
    -120 => :deprecated,
    -121 => :bad_ser_invert,
    -122 => :bad_edge,
    -123 => :bad_isr_init,
    -124 => :bad_forever,
    -125 => :bad_filter,
    -126 => :bad_pad,
    -127 => :bad_strength,
    -128 => :fil_open_failed,
    -129 => :bad_file_mode,
    -130 => :bad_file_flag,
    -131 => :bad_file_read,
    -132 => :bad_file_write,
    -133 => :file_not_ropen,
    -134 => :file_not_wopen,
    -135 => :bad_file_seek,
    -136 => :no_file_match,
    -137 => :no_file_access,
    -138 => :file_is_a_dir,
    -139 => :bad_shell_status,
    -140 => :bad_script_name,
    -141 => :bad_spi_baud,
    -142 => :not_spi_gpio,
    -143 => :bad_event_id
  }

  @spec error_reason(neg_integer) :: :atom
  def error_reason(code) do
    @error_code_map[code] || :unknown_error
  end
end
