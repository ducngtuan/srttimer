require 'minitest/unit'

class TestSRTTimer < MiniTest::Unit::TestCase
  def test_parse_str
    line = '01:02:50,730 --> 01:02:53,010'
    start, stop = parse_str(line)
    assert_equal [1, 2, 50, 730], start
    assert_equal [1, 2, 53, 10], stop
  end

  def test_time_to_s
    time = [1, 0, 50, 73]
    assert_equal '01:00:50,073', time_to_s(time)
  end

  def test_shift_time
    time = [1, 0, 50, 73]
    assert_equal [1, 1, 25, 73], shift(time, 35)
    assert_equal [1, 0, 20, 73], shift(time, -30)
  end
end

def parse_str(str)
  start, stop =  str.scan(/(\d+):(\d+):(\d+),\s*(\d+)/)
                    .map { |x| x.map { |e| e.to_i } }
  return [start, stop]
end

def time_to_s(time)
  h, m, s, ms = time.map { |i| i.to_s }
  return "#{h.rjust(2, "0")}:#{m.rjust(2, "0")}:#{s.rjust(2, "0")},#{ms.rjust(3, "0")}"
end

def shift(time, s_diff)
  h, m, s, ms = time
  s += s_diff
  m, s = m + s / 60, s % 60
  h, m = h + m / 60, m % 60
  return [h, m, s, ms]
end

if ARGV.length != 2
  puts "Usage: ruby #{$0} [file name] [seconds different]"
  puts "[seconds different] can be negative"
  exit(0)
end

output = File.open(File.basename(ARGV[0], '.srt') + '_new.srt', 'w')
diff = ARGV[1].to_i

File.open(ARGV[0]).each_line do |line|
  if line =~ /\d+:\d+:\d+,\d+\s*-->\s*\d+:\d+:\d+,\d+/
    start, stop = parse_str(line).map { |time| shift(time, diff) }
    output.puts(time_to_s(start) + ' --> ' + time_to_s(stop))
  else
    output.write(line)
  end
end
output.flush.close