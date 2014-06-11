module BuildingsHelper

ADDRESS_REPLACEMENTS = {
                        'E' => 'EAST',
                        'W' => 'WEST',                 
                        'ST' => 'STREET',
                        'AVE' => 'AVENUE',
                        'BLVD' => 'BOULEVARD',
                        'PL' => 'PLACE',
                        'PKWY' => 'PARKWAY',
                        'RD' => 'ROAD',
                        'DR' => 'DRIVE',
                        'CT' => 'COURT',
                        'FIRST' => '1',
                        'SECOND' => '2',
                        'THIRD' => '3',
                        'FOURTH' => '4',
                        'FIFTH' => '5',
                        'SIXTH' => '6',
                        'SEVENTH' => '7',
                        'EIGHT' => '8',
                        'NINTH' => '9',
                        'TENTH' => '10',
                        'ELEVENTH' => '11',
                        'TWELTH' => '12',
                        'THIRTEENTH' => '13',
                        'FOURTEENTH' => '14',
                        'FIFTEENTH' => '15',
                        'SIXTEENTH' => '16',
                        'SEVENTEENTH' => '17',
                        'EIGTHEENTH' =>'18',
                        'NINETEENTH' => '19',
                        'TWENTIETH' => '20'
                        }

REGEX_FOR_NUMBERS = /\dND|\dST|\dRD|\dTH/

  def standardize_address_input(address)
    address = address.upcase.gsub(/[.,#;]/, '').split

    address[1..-1].collect do |word|
      word.gsub!(word, ADDRESS_REPLACEMENTS) if ADDRESS_REPLACEMENTS[word]
      word.gsub!(word.match(REGEX_FOR_NUMBERS)[0], word.match(REGEX_FOR_NUMBERS)[0][0]) if word.match(REGEX_FOR_NUMBERS)
    end
    address = address.join(' ')
  end

end