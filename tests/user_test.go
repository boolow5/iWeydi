package test

import (
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"runtime"
	"testing"

	_ "github.com/boolow5/iWeydi/routers"

	"github.com/astaxie/beego"
	. "github.com/smartystreets/goconvey/convey"
)

func init() {
	_, file, _, _ := runtime.Caller(1)
	apppath, _ := filepath.Abs(filepath.Dir(filepath.Join(file, ".."+string(filepath.Separator))))
	beego.TestBeegoInit(apppath)
}

// TestUserAPI is a sample to run an endpoint test
func TestUserAPIGetIsAvailable(t *testing.T) {
	r, _ := http.NewRequest("GET", "/api/user", nil)
	w := httptest.NewRecorder()
	w.Header().Set("Content-Type", "application/json")
	beego.BeeApp.Handlers.ServeHTTP(w, r)

	beego.Trace("testing", "TestUserAPIGetIsAvailable", "Code[%d]\n%s", w.Code, w.Body.String())

	Convey("Subject: Test Station Endpoint\n", t, func() {
		Convey("Status Code Should Be 200", func() {
			So(w.Code, ShouldEqual, 200)
		})
		Convey("The Result Should Not Be Empty", func() {
			So(w.Body.Len(), ShouldBeGreaterThan, 0)
		})
		Convey("The Result Should Be in JSON format", func() {
			So(w.Body.String(), ShouldStartWith, `{
	"user":`)
		})
	})
}

// TestUserAPI is a sample to run an endpoint test
func TestUserAPIPostIsAvailable(t *testing.T) {
	r, _ := http.NewRequest("POST", "/api/user", nil)
	w := httptest.NewRecorder()
	w.Header().Set("Content-Type", "application/json")

	beego.BeeApp.Handlers.ServeHTTP(w, r)

	beego.Trace("testing", "TestUserAPIPostIsAvailable", "Code[%d]\n%s", w.Code, w.Body.String())

	Convey("Subject: Test Station Endpoint\n", t, func() {
		Convey("Status Code Should Be 200", func() {
			So(w.Code, ShouldEqual, 200)
		})
		Convey("The Result Should Not Be Empty", func() {
			So(w.Body.Len(), ShouldBeGreaterThan, 0)
		})
		Convey("The Result Should Be in JSON format", func() {
			So(w.Body.String(), ShouldStartWith, "{")
		})
		Convey(`The Result Should Contain {
"success": "Successfully registred new user"
}`, func() {
			So(w.Body.String(), ShouldEqual, `{
  "success": "Successfully registred new user"
}`)
		})
	})
}
