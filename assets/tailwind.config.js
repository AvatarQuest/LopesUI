module.exports = {
    purge: [
       '../lib/**/*.ex',
       '../lib/**/*.leex',
       '../lib/**/*.eex',
       './js/**/*.js'
     ],
     darkMode: false, // or 'media' or 'class'
     theme: {
      extend: {
        backgroundImage: {
         'lucas-ui': "url('/images/lucas-ui.png')",
         'valleyfire': "url('/images/valleyfire.png')",
        },
        backgroundPosition: {
          bottom: 'bottom',
         'bottom-4': 'center bottom 1rem',
          center: 'center',
          'center-4': 'center 1rem',
          left: 'left',
         'left-bottom': 'left bottom',
         'left-top': 'left top',
          right: 'right',
          'right-bottom': 'right bottom',
          'right-top': 'right top',
          top: 'top',
        //  'top-4': 'center top -2rem',
        }
      }
    },
     variants: {
       extend: {
         backgroundColor: ["responsive", "hover", "focus", "disabled", "checked"],
         borderColor: ["responsive", "hover", "focus", "checked"],
         borderStyle: ["responsive", "disabled", "checked"],
         boxShadow: ["responsive", "hover", "focus", "disabled", "checked"],
         cursor: ["responsive", "hover"],
         textColor: ["responsive", "hover", "focus", "checked"],
         padding: ["responsive", "disabled"],
       },
     },
     plugins: [],
   }