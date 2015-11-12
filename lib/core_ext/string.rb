# encoding: UTF-8
class String

  def wrap
    [self]
  end


  def query_to_hash
    keyvals = self.split('&').inject({}) do |result, q|
      k,v = q.split('=')
      if !v.nil?
         result.merge({k => v})
      elsif !result.key?(k)
        result.merge({k => true})
      else
        result
      end
    end
    keyvals
  end

  def initial
    self[0,1]
  end

  def from_json( default = {} )
    JSON.load(self) rescue default
  end

  def to_md5
    Digest::MD5.hexdigest(self)
  end

  def en_to_ru
    str = self.dup
    ru_hash = {'q'=>'й','w'=>'ц','e'=>'у','r'=>'к','t'=>'е','y'=>'н','u'=>'г','i'=>'ш','o'=>'щ','p'=>'з','['=>'х',']'=>'ъ','a'=>'ф','s'=>'ы','d'=>'в','f'=>'а','g'=>'п','h'=>'р','j'=>'о','k'=>'л','l'=>'д',';'=>'ж',"'"=>'э','z'=>'я','x'=>'ч','c'=>'с','v'=>'м','b'=>'и','n'=>'т','m'=>'ь',','=>'б','.'=>'ю','/'=>'.'}
    ru_hash.each {|k,v| str.gsub!(k,v)}
    str
  end

  def en_to_uk
    str = self.dup
    uk_hash = {'q'=>'й','w'=>'ц','e'=>'у','r'=>'к','t'=>'е','y'=>'н','u'=>'г','i'=>'ш','o'=>'щ','p'=>'з','['=>'х',']'=>'ї','a'=>'ф','s'=>'і','d'=>'в','f'=>'а','g'=>'п','h'=>'р','j'=>'о','k'=>'л','l'=>'д',';'=>'ж',"'"=>'є','z'=>'я','x'=>'ч','c'=>'с','v'=>'м','b'=>'и','n'=>'т','m'=>'ь',','=>'б','.'=>'ю','/'=>'.'}
    uk_hash.each {|k,v| str.gsub!(k,v)}
    str
  end

  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def russian_translit!
      self.gsub!(self,self.russian_translit(self))
  end
  def russian_translit text=""
      text = text.empty? ? self : text
      text = text.gsub_arr(["?","!"],"")
      p text
      translited = text.tr('абвгдеёзийклмнопрстуфхэыь ', 'abvgdeezijklmnoprstufhey\'-')
      translited = translited.tr('АБВГДЕЁЗИЙКЛМНОПРСТУФХЭ ', 'abvgdeezijklmnoprstufhey\'-')
      translited = translited.gsub(/[жцчшщъюяЖЦЧШЩЪЮЯ]/,
          'ж' => 'zh', 'ц' => 'ts', 'ч' => 'ch', 'ш' => 'sh', 'щ' => 'sch', 'ъ' => '', 'ю' => 'ju', 'я' => 'ja',
          'Ж' => 'zh', 'Ц' => 'ts', 'Ч' => 'ch', 'Ш' => 'sh', 'Щ' => 'sch', 'Ъ' => '', 'Ю' => 'ju', 'Я' => 'ja')
  end
  def gsub_arr arr,str
    arr.each{|s| self.gsub!(s,str)}
    self
  end
end
