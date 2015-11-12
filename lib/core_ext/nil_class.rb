class NilClass
  def russian_translit!
      self.gsub!(self,self.russian_translit(self))
  end
  def initial
    ""
  end
  def russian_translit text=""
      text = text.gsub_arr(["?","!"],"")

      translited = text.tr('абвгдеёзийклмнопрстуфхэыь ', 'abvgdeezijklmnoprstufhey\'-')
      translited = translited.tr('АБВГДЕЁЗИЙКЛМНОПРСТУФХЭ ', 'ABVGDEEZIJKLMNOPRSTUFHEY\'-')
      translited = translited.gsub(/[жцчшщъюяЖЦЧШЩЪЮЯ]/,
          'ж' => 'zh', 'ц' => 'ts', 'ч' => 'ch', 'ш' => 'sh', 'щ' => 'sch', 'ъ' => '', 'ю' => 'ju', 'я' => 'ja',
          'Ж' => 'ZH', 'Ц' => 'TS', 'Ч' => 'CH', 'Ш' => 'SH', 'Щ' => 'SCH', 'Ъ' => '', 'Ю' => 'JU', 'Я' => 'JA')
  end

  def to_a
    []
  end

  def wrap
    [self]
  end
end
