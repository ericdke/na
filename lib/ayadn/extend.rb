# encoding: utf-8
class String
  def is_integer?
    begin
      temp = self.to_i.to_s
      return false if temp == "0"
      Integer(temp)
      return true
    rescue ArgumentError
      return false
    end
  end
end
class Integer
  def to_filesize
    {
      'B'  => 1024,
      'KB' => 1024 * 1024,
      'MB' => 1024 * 1024 * 1024,
      'GB' => 1024 * 1024 * 1024 * 1024,
      'TB' => 1024 * 1024 * 1024 * 1024 * 1024
    }.each_pair { |e, s| return "#{(self.to_f / (s / 1024)).round(2)} #{e}" if self < s }
  end
end
class Object
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end
end