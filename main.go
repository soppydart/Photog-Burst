package main

import (
	"fmt"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/gorilla/csrf"
	"github.com/soppydart/Photog-Burst/controllers"
	"github.com/soppydart/Photog-Burst/migrations"
	"github.com/soppydart/Photog-Burst/models"
	"github.com/soppydart/Photog-Burst/templates"
	"github.com/soppydart/Photog-Burst/views"
)

func main() {
	// Set up the database
	cfg := models.DefaultPostgresConfig()
	db, err := models.Open(cfg)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	err = models.MigrateFS(db, migrations.FS, ".")
	if err != nil {
		panic(err)
	}

	// Set up services
	userService := models.UserService{
		DB: db,
	}
	sessionService := models.SessionService{
		DB: db,
	}

	//Set up middleware
	umw := controllers.UserMiddleware{
		SessionService: &sessionService,
	}

	csrfKey := "sw60rn5lakz0ohd5qaz87l39z1lj913a"
	csrfMw := csrf.Protect([]byte(csrfKey), csrf.Secure(false))

	//Set up controllers
	usersC := controllers.Users{
		UserService:    &userService,
		SessionService: &sessionService,
	}
	usersC.Templates.New = views.Must(views.ParseFS(
		templates.FS, "signup.gohtml", "layout.gohtml"))
	usersC.Templates.SignIn = views.Must(views.ParseFS(
		templates.FS, "signin.gohtml", "layout.gohtml"))

	// Set up routes
	r := chi.NewRouter()
	r.Use(csrfMw)
	r.Use(umw.SetUser)
	r.Get("/", controllers.StaticHandler(
		views.Must(views.ParseFS(
			templates.FS, "home.gohtml", "layout.gohtml"))))
	r.Get("/contact", controllers.StaticHandler(
		views.Must(views.ParseFS(
			templates.FS, "contact.gohtml", "layout.gohtml"))))
	r.Get("/signup", usersC.New)
	r.Get("/signin", usersC.SignIn)
	r.Post("/signin", usersC.ProcessSignIn)
	r.Post("/users", usersC.Create)
	r.Post("/signout", usersC.ProcessSignOut)
	r.Route("/users/me", func(r chi.Router) {
		r.Use(umw.RequireUser)
		r.Get("/", usersC.CurrentUser)
	})
	r.NotFound(func(w http.ResponseWriter, r *http.Request) {
		http.Error(w, "Page Not Found!", http.StatusNotFound)
	})

	// Start the server
	fmt.Println("Starting the server on port 3000...")
	err = http.ListenAndServe(":3000", r)
	if err != nil {
		panic(err)
	}
}
