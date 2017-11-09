class UserAgentParserTest < MTest::Unit::TestCase
  def test_ua_parse
    ua = UserAgentParser::UserAgent.new('Chrome')
    assert_equal(ua.to_s, 'Chrome')
  end

  def test_ua_version
    version = UserAgentParser::Version.new('1.2.3pre')
    agent = UserAgentParser::UserAgent.new('Chrome', version)
    assert_equal(agent.to_s, 'Chrome 1.2.3pre')
  end

  def test_family
    agent = UserAgentParser::UserAgent.new('Chromium')
    assert_equal(agent.family, 'Chromium')
  end

  def test_other_family
    agent = UserAgentParser::UserAgent.new
    assert_equal(agent.family, 'Other')
  end

  def test_version
    version = UserAgentParser::Version.new('1.2.3')
    agent = UserAgentParser::UserAgent.new(nil, version)
    assert_equal(agent.version, version)
  end

  def test_os
    os = UserAgentParser::OperatingSystem.new('Windows XP')
    agent = UserAgentParser::UserAgent.new(nil, nil, os)
    assert_equal(agent.os, os)
  end

  def test_device
    device = UserAgentParser::Device.new('iPhone')
    agent = UserAgentParser::UserAgent.new(nil, nil, nil, device)
    assert_equal(agent.device, device)
  end

  def test_name
    agent = UserAgentParser::UserAgent.new('Safari')
    assert_equal(agent.name, agent.family)
  end

  def test_agent
    version = UserAgentParser::Version.new('1.0')
    agent1 = UserAgentParser::UserAgent.new('Chrome', version)
    agent2 = UserAgentParser::UserAgent.new('Chrome', version)
    assert_equal(agent1, agent2)
  end

  def test_same_agent_os
    version = UserAgentParser::Version.new('1.0')
    os = UserAgentParser::OperatingSystem.new('Windows')
    agent1 = UserAgentParser::UserAgent.new('Chrome', version, os)
    agent2 = UserAgentParser::UserAgent.new('Chrome', version, os)
    assert_equal(agent1, agent2)
  end

  def test_different_os
    version = UserAgentParser::Version.new('1.0')
    windows = UserAgentParser::OperatingSystem.new('Windows')
    mac = UserAgentParser::OperatingSystem.new('Mac')
    agent1 = UserAgentParser::UserAgent.new('Chrome', version, windows)
    agent2 = UserAgentParser::UserAgent.new('Chrome', version, mac)
    assert_not_equal(agent1, agent2)
  end

  def test_different_version
    browser_version1 = UserAgentParser::Version.new('1.0')
    browser_version2 = UserAgentParser::Version.new('2.0')
    os = UserAgentParser::OperatingSystem.new('Windows')
    agent1 = UserAgentParser::UserAgent.new('Chrome', browser_version1, os)
    agent2 = UserAgentParser::UserAgent.new('Chrome', browser_version2, os)
    assert_not_equal(agent1, agent2)
  end

  def test_same_agent
    version = UserAgentParser::Version.new('1.0')
    agent1 = UserAgentParser::UserAgent.new('Chrome', version)
    agent2 = UserAgentParser::UserAgent.new('Chrome', version)
    assert_equal true, agent1.eql?(agent2)
  end

  def test_same_os
    version = UserAgentParser::Version.new('1.0')
    os = UserAgentParser::OperatingSystem.new('Windows')
    agent1 = UserAgentParser::UserAgent.new('Chrome', version, os)
    agent2 = UserAgentParser::UserAgent.new('Chrome', version, os)
    assert_equal true, agent1.eql?(agent2)
  end

  def test_different_os
    version = UserAgentParser::Version.new('1.0')
    windows = UserAgentParser::OperatingSystem.new('Windows')
    mac = UserAgentParser::OperatingSystem.new('Mac')
    agent1 = UserAgentParser::UserAgent.new('Chrome', version, windows)
    agent2 = UserAgentParser::UserAgent.new('Chrome', version, mac)
    assert_equal false, agent1.eql?(agent2)
  end

  def test_different_version
    browser_version1 = UserAgentParser::Version.new('1.0')
    browser_version2 = UserAgentParser::Version.new('2.0')
    os = UserAgentParser::OperatingSystem.new('Windows')
    agent1 = UserAgentParser::UserAgent.new('Chrome', browser_version1, os)
    agent2 = UserAgentParser::UserAgent.new('Chrome', browser_version2, os)
    assert_equal false, agent1.eql?(agent2)
  end

  def test_family_version
    browser_version = UserAgentParser::Version.new('1.0')
    agent = UserAgentParser::UserAgent.new('Chrome', browser_version)
    assert_equal agent.inspect.to_s, '#<UserAgentParser::UserAgent Chrome 1.0>'
  end

  def test_os_if_present
    browser_version = UserAgentParser::Version.new('1.0')
    os_version = UserAgentParser::Version.new('10.7.4')
    os = UserAgentParser::OperatingSystem.new('OS X', os_version)
    agent = UserAgentParser::UserAgent.new('Chrome', browser_version, os)
    assert_equal agent.inspect.to_s, '#<UserAgentParser::UserAgent Chrome 1.0 (OS X 10.7.4)>'
  end

  def test_device_if_present
    browser_version = UserAgentParser::Version.new('5.0.2')
    os_version = UserAgentParser::Version.new('4.2.1')
    os = UserAgentParser::OperatingSystem.new('iOS', os_version)
    device = UserAgentParser::Device.new('iPhone')
    agent = UserAgentParser::UserAgent.new('Mobile Safari', browser_version, os, device)
    assert_equal agent.inspect.to_s, '#<UserAgentParser::UserAgent Mobile Safari 5.0.2 (iOS 4.2.1) (iPhone)>'
  end
end

class GeneralParseTest < MTest::Unit::TestCase
  def test_parse
    user_agent = UserAgentParser.parse 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0;)'
    assert_equal(user_agent.to_s, "IE 9.0")
    assert_equal(user_agent.family, "IE")
    assert_equal(user_agent.version.to_s, "9.0")
    assert_equal(user_agent.version.major, "9")
    assert_equal(user_agent.version.minor, "0")
    assert_equal(user_agent.version.minor, "0")

    operating_system = user_agent.os
    assert_equal(operating_system.to_s, "Windows Vista")
  end
end

if __FILE__ == $0
  MTest::Unit.new.run
end