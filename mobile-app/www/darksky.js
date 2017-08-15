class DarkSky {
    constructor() {
        this.long = null;
        this.lat = null;
        this.t = null;
        this.token = DARKSKY_TOKEN
        this.query = {}
    }

    longitude(long) {
        !long ? null : this.long = long;
        return this;
    }

    latitude(lat) {
        !lat ? null : this.lat = lat;
        return this;
    }

    time(time) {
        !time ? null : this.t = moment(time).format('YYYY-MM-DDTHH:mm:ss');
        return this;
    }

    units(unit) {
        !unit ? null : this.query.units = unit;
        return this;
    }

    language(lang) {
        !lang ? null : this.query.lang = lang;
        return this;
    }

    exclude(blocks) {
        !blocks ? null : this.query.exclude = blocks;
        return this;
    }

    extendHourly(param) {
        !param ? null : this.query.extend = 'hourly';
        return this;
    }

    generateReqUrl(lat, lng) {
        this.url = 'https://api.darksky.net/forecast/'+this.token+'/'+lat+','+lng;
    }

    get() {
        return new Promise((resolve, reject) => {
            if(!this.lat || !this.long) reject("Request not sent. ERROR: Longitute or Latitude is missing.")
            this.generateReqUrl(this.lat, this.long);

            $.ajax({
              url: this.url,
              dataType: "jsonp",
              success: (data) => {
                // console.log(data)
                raindialogTag.setData(_.pluck(data.hourly.data,'humidity').slice(0,25))
                if(raindialogTag.data[13]>raindialogTag.threshold)
                    homeTag.addState('rain')

                var result = {
                   temp : data.currently.temperature,
                   summary : data.currently.summary
                }

                resolve(result)
                }
            });

           
        })
    }
}

forecast = new DarkSky()
