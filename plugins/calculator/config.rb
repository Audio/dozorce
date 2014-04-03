#encoding: utf-8

module Calculator

    _float_num = /\d+(?:(?:\.|,)\d+)?/

    _unit = /[a-zA-Z]+/

    Config = {
      :routes => {
        :standard_prefix => /c +(.+)/,
        :symbol_prefix => /^(\S) *(#{_float_num})$/,
        :symbol_postfix => /^(#{_float_num}) *(\S)$/,
        :converter_long => /^(#{_float_num}) +(#{_unit}) +to +(#{_unit})$/,
        :converted_short => /^(#{_float_num}) +(#{_unit})$/
      },
      :app_id => '9U7YJH-GJAQRRH92L',
      :to => 'czk',
      :from => ['usd', 'eur'],
      :symbols => {
          :usd   => '$',
          :eur   => '€',
          :pound => '£'
      }
    }

end
