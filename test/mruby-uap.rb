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

  def test_different_os2
    version = UserAgentParser::Version.new('1.0')
    windows = UserAgentParser::OperatingSystem.new('Windows')
    mac = UserAgentParser::OperatingSystem.new('Mac')
    agent1 = UserAgentParser::UserAgent.new('Chrome', version, windows)
    agent2 = UserAgentParser::UserAgent.new('Chrome', version, mac)
    assert_not_equal(agent1, agent2)
  end

  def test_different_version2
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

class VersionTest < MTest::Unit::TestCase
  def test_parse_major
    version = UserAgentParser::Version.new('1')
    assert_equal(version.major, '1')
  end

  def test_parse_major_minor
    version = UserAgentParser::Version.new('1.2')
    assert_equal(version.major, '1')
    assert_equal(version.minor, '2')
  end

  def test_parse_major_minor_patch
    version = UserAgentParser::Version.new('1.2.3')
    assert_equal(version.major, '1')
    assert_equal(version.minor, '2')
    assert_equal(version.patch, '3')
  end

  def test_parse_minor_patch
    version = UserAgentParser::Version.new('1.2.3b4')
    assert_equal(version.major, '1')
    assert_equal(version.minor, '2')
    assert_equal(version.patch, '3')
    assert_equal(version.patch_minor, 'b4')
  end

  def test_parse_minor_patch_bar
    version = UserAgentParser::Version.new('1.2.3-b4')
    assert_equal(version.major, '1')
    assert_equal(version.minor, '2')
    assert_equal(version.patch, '3')
    assert_equal(version.patch_minor, 'b4')
  end

  def test_parse_pre_patch
    version = UserAgentParser::Version.new('1.2.3pre')
    assert_equal(version.major, '1')
    assert_equal(version.minor, '2')
    assert_equal(version.patch, '3pre')
  end

  def test_parse_patch_bar
    version = UserAgentParser::Version.new('1.2.3-45')
    assert_equal(version.major, '1')
    assert_equal(version.minor, '2')
    assert_equal(version.patch, '3-45')
  end

  def test_parse_minor_patch_array
    version = UserAgentParser::Version.new(1, '2a', 3, '4b')
    assert_equal(version.major, '1')
    assert_equal(version.minor, '2a')
    assert_equal(version.patch, '3')
    assert_equal(version.patch_minor, '4b')
  end

  def test_to_s
    version = UserAgentParser::Version.new('1.2.3b4')
    assert_equal(version.to_s, '1.2.3b4')
  end

  def test_same_version
    version = UserAgentParser::Version.new('1.2.3')
    assert_equal(version, UserAgentParser::Version.new('1.2.3'))
  end

  def test_different_version
    version = UserAgentParser::Version.new('1.2.3')
    assert_not_equal(version, UserAgentParser::Version.new('1.2.2'))
  end

  def test_version_inspect
    version = UserAgentParser::Version.new('1.2.3')
    assert_equal(version.inspect, '#<UserAgentParser::Version 1.2.3>')
  end
end

class OSTest < MTest::Unit::TestCase
  def test_name_family
    os = UserAgentParser::OperatingSystem.new('Windows')
    assert_equal(os.name, os.family)
  end

  def test_to_s
    os = UserAgentParser::OperatingSystem.new('Windows')
    assert_equal(os.to_s, 'Windows')
  end

  def test_version_os
    version = UserAgentParser::Version.new('7')
    os = UserAgentParser::OperatingSystem.new('Windows', version)
    assert_equal(os.to_s, 'Windows 7')
  end

  def test_same_os
    version = UserAgentParser::Version.new('7')
    os1 = UserAgentParser::OperatingSystem.new('Windows', version)
    os2 = UserAgentParser::OperatingSystem.new('Windows', version)
    assert_equal(os1, os2)
  end

  def test_different_version_os
    seven = UserAgentParser::Version.new('7')
    eight = UserAgentParser::Version.new('8')
    os1 = UserAgentParser::OperatingSystem.new('Windows', seven)
    os2 = UserAgentParser::OperatingSystem.new('Windows', eight)
    assert_not_equal(os1, os2)
  end

  def test_different_os
    version = UserAgentParser::Version.new('7')
    os1 = UserAgentParser::OperatingSystem.new('Windows', version)
    os2 = UserAgentParser::OperatingSystem.new('Blah', version)
    assert_not_equal(os1, os2)
  end

  def test_same_os_eql
    version = UserAgentParser::Version.new('7')
    os1 = UserAgentParser::OperatingSystem.new('Windows', version)
    os2 = UserAgentParser::OperatingSystem.new('Windows', version)
    assert_equal true, os1.eql?(os2)
  end

  def test_different_version_eql
    seven = UserAgentParser::Version.new('7')
    eight = UserAgentParser::Version.new('8')
    os1 = UserAgentParser::OperatingSystem.new('Windows', seven)
    os2 = UserAgentParser::OperatingSystem.new('Windows', eight)
    assert_equal false, os1.eql?(os2)
  end

  def test_different_os_eql
    version = UserAgentParser::Version.new('7')
    os1 = UserAgentParser::OperatingSystem.new('Windows', version)
    os2 = UserAgentParser::OperatingSystem.new('Blah', version)
    assert_equal false, os1.eql?(os2)
  end

  def test_os_inspect
    version = UserAgentParser::Version.new('10.7.4')
    os = UserAgentParser::OperatingSystem.new('OS X', version)
    assert_equal os.inspect.to_s, '#<UserAgentParser::OperatingSystem OS X 10.7.4>'
  end
end

class DeviceTest < MTest::Unit::TestCase
  def test_name
    os = UserAgentParser::Device.new('iPod')
    assert_equal(os.name, os.family)
  end

  def test_to_s
    os = UserAgentParser::Device.new('iPod')
    assert_equal(os.to_s, 'iPod')
  end

  def test_same_device
    device1 = UserAgentParser::Device.new('iPod')
    device2 = UserAgentParser::Device.new('iPod')
    assert_equal(device1, device2)
  end

  def test_different_device
    device1 = UserAgentParser::Device.new('iPod')
    device2 = UserAgentParser::Device.new('iPad')
    assert_not_equal(device1, device2)
  end

  def test_same_device_eql
    device1 = UserAgentParser::Device.new('iPod')
    device2 = UserAgentParser::Device.new('iPod')
    assert_equal true, device1.eql?(device2)
  end

  def test_different_device_eql
    device1 = UserAgentParser::Device.new('iPod')
    device2 = UserAgentParser::Device.new('iPad')
    assert_equal false, device1.eql?(device2)
  end

  def test_os_inspect
    device = UserAgentParser::Device.new('iPod')
    assert_equal(device.inspect.to_s, '#<UserAgentParser::Device iPod>')
  end
end

class UapCoreCaseTest < MTest::Unit::TestCase
  PARSER = UserAgentParser::Parser.new

  def file_to_yaml(resource)
    uap_path = File.expand_path('../../uap-core', __FILE__)
    resource_path = File.join(uap_path, resource)
    yml_str = File.read(resource_path)
    YAML.load(yml_str)
  end

  def file_to_test_cases(file)
    file_to_yaml(file)['test_cases'].map do |test_case|
      {
          'user_agent_string' => test_case['user_agent_string'],
          'family'            => test_case['family'],
          'major'             => test_case['major'],
          'minor'             => test_case['minor'],
          'patch'             => test_case['patch'],
          'patch_minor'       => test_case['patch_minor'],
          'brand'             => test_case['brand'],
          'model'             => test_case['model']
      }
    end.reject do |test_case|
      # We don't do the hacky javascript user agent overrides
      test_case.key?('js_ua') ||
          test_case['family'] == 'IE Platform Preview' ||
          test_case['user_agent_string'].include?('chromeframe;')
    end
  end

  def user_agent_test_cases
    file_to_test_cases('test_resources/firefox_user_agent_strings.yaml')
    file_to_test_cases('tests/test_ua.yaml')
  end

  def operating_system_test_cases
    file_to_test_cases('tests/test_os.yaml') +
        file_to_test_cases('test_resources/additional_os_tests.yaml')
  end

  def device_test_cases
    file_to_test_cases('tests/test_device.yaml')
  end

  def test_parse_UA
    user_agent_test_cases.each do |test_case|
      user_agent = PARSER.parse(test_case['user_agent_string'])
      if test_case['family']
        assert_equal(user_agent.family, test_case['family'])
      end

      if test_case['major']
        assert_equal(user_agent.version.major, test_case['major'])
      end

      if test_case['minor']
        assert_equal(user_agent.version.minor, test_case['minor'])
      end

      if test_case['patch']
        assert_equal(user_agent.version.patch, test_case['patch'])
      end
    end
  end

  def test_parse_os
    operating_system_test_cases.each do |test_case|
      user_agent = PARSER.parse(test_case['user_agent_string'])
      operating_system = user_agent.os

      if test_case['family']
        assert_equal(operating_system.family, test_case['family'])
      end

      if test_case['major']
        assert_equal(operating_system.version.major, test_case['major'])
      end

      if test_case['minor']
        assert_equal(operating_system.version.minor, test_case['minor'])
      end

      if test_case['patch']
        assert_equal(operating_system.version.patch, test_case['patch'])
      end

      if test_case['patch_minor']
        assert_equal(operating_system.version.patch_minor, test_case['patch_minor'])
      end
    end
  end

  def test_parse_device
    device_test_cases.each do |test_case|
      user_agent = PARSER.parse(test_case['user_agent_string'])
      device = user_agent.device

      if test_case['family']
        assert_equal(device.family, test_case['family'])
      end

      if test_case['model']
        assert_equal(device.model, test_case['model'])
      end

      if test_case['brand']
        assert_equal(device.brand, test_case['brand'])
      end
    end
  end
end

if __FILE__ == $0
  MTest::Unit.new.run
end