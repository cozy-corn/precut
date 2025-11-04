// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import "./qr_reader"
import { Autocomplete } from 'stimulus-autocomplete' //コンポーネントを読み込むための記述

const application = Application.start()
application.register('autocomplete', Autocomplete) //コンポーネントにあるAutocompleteコントローラを使えるようにするための記述