const express = require('express')  //require express
const app = express()  //using express function create app const variable
const port = process.env.PORT || 8000;
const path = require('path')
const hbs = require('hbs')  // require hbs engine

//find static path
const static_path = path.join(__dirname, '../public')
//find templates.views folder
const template_path = path.join(__dirname, '../templates/views')
//find partial folder path
const partials_path = path.join(__dirname, '../templates/partials')

app.use(express.static(static_path));

//set hbs engine
app.set('view engine', 'hbs');
app.set('views', template_path);
hbs.registerPartials(partials_path);

//Routing
app.get("/", (req, res) => {
    res.render('index')
});

app.get('/about', (req, res) => {
    res.render('about')
});

app.get('/weather', (req, res) => {
    res.render('weather')
});

app.get('*', (req, res) => {
    res.render('404error', {
        errmsg: "Opps! Page not "
    })
});

app.listen(port, () => {
    console.log(`Server Listen at PORT ${port}`);
});
