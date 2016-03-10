library angular2.test.router.integration.impl.sync_route_spec_impl;

import "package:angular2/testing_internal.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        beforeEachProviders,
        expect,
        iit,
        flushMicrotasks,
        inject,
        it,
        TestComponentBuilder,
        ComponentFixture,
        xit;
import "../util.dart"
    show specs, compile, TEST_ROUTER_PROVIDERS, clickOnElement, getHref;
import "package:angular2/platform/common_dom.dart" show By;
import "package:angular2/router.dart" show Router, Route, Location;
import "fixture_components.dart"
    show
        HelloCmp,
        UserCmp,
        TeamCmp,
        ParentCmp,
        ParentWithDefaultCmp,
        DynamicLoaderCmp;
import "package:angular2/src/facade/async.dart" show PromiseWrapper;

getLinkElement(ComponentFixture rtc) {
  return rtc.debugElement.query(By.css("a")).nativeElement;
}

syncRoutesWithoutChildrenWithoutParams() {
  var fixture;
  var tcb;
  var rtr;
  beforeEachProviders(() => TEST_ROUTER_PROVIDERS);
  beforeEach(inject([TestComponentBuilder, Router], (tcBuilder, router) {
    tcb = tcBuilder;
    rtr = router;
  }));
  it(
      "should navigate by URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb)
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config(
                [new Route(path: "/test", component: HelloCmp, name: "Hello")]))
            .then((_) => rtr.navigateByUrl("/test"))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement).toHaveText("hello");
              async.done();
            });
      }));
  it(
      "should navigate by link DSL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb)
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config(
                [new Route(path: "/test", component: HelloCmp, name: "Hello")]))
            .then((_) => rtr.navigate(["/Hello"]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement).toHaveText("hello");
              async.done();
            });
      }));
  it(
      "should generate a link URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb,
                '''<a [routerLink]="[\'Hello\']">go to hello</a> | <router-outlet></router-outlet>''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config(
                [new Route(path: "/test", component: HelloCmp, name: "Hello")]))
            .then((_) {
              fixture.detectChanges();
              expect(getHref(getLinkElement(fixture))).toEqual("/test");
              async.done();
            });
      }));
  it(
      "should navigate from a link click",
      inject([AsyncTestCompleter, Location], (async, location) {
        compile(tcb,
                '''<a [routerLink]="[\'Hello\']">go to hello</a> | <router-outlet></router-outlet>''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config(
                [new Route(path: "/test", component: HelloCmp, name: "Hello")]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("go to hello | ");
              rtr.subscribe((_) {
                fixture.detectChanges();
                expect(fixture.debugElement.nativeElement)
                    .toHaveText("go to hello | hello");
                expect(location.urlChanges).toEqual(["/test"]);
                async.done();
              });
              clickOnElement(getLinkElement(fixture));
            });
      }));
}

syncRoutesWithoutChildrenWithParams() {
  var fixture;
  var tcb;
  var rtr;
  beforeEachProviders(() => TEST_ROUTER_PROVIDERS);
  beforeEach(inject([TestComponentBuilder, Router], (tcBuilder, router) {
    tcb = tcBuilder;
    rtr = router;
  }));
  it(
      "should navigate by URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb)
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/user/:name", component: UserCmp, name: "User")
                ]))
            .then((_) => rtr.navigateByUrl("/user/igor"))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("hello igor");
              async.done();
            });
      }));
  it(
      "should navigate by link DSL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb)
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/user/:name", component: UserCmp, name: "User")
                ]))
            .then((_) => rtr.navigate([
                  "/User",
                  {"name": "brian"}
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("hello brian");
              async.done();
            });
      }));
  it(
      "should generate a link URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb,
                '''<a [routerLink]="[\'User\', {name: \'naomi\'}]">greet naomi</a> | <router-outlet></router-outlet>''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/user/:name", component: UserCmp, name: "User")
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(getHref(getLinkElement(fixture))).toEqual("/user/naomi");
              async.done();
            });
      }));
  it(
      "should navigate from a link click",
      inject([AsyncTestCompleter, Location], (async, location) {
        compile(tcb,
                '''<a [routerLink]="[\'User\', {name: \'naomi\'}]">greet naomi</a> | <router-outlet></router-outlet>''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/user/:name", component: UserCmp, name: "User")
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("greet naomi | ");
              rtr.subscribe((_) {
                fixture.detectChanges();
                expect(fixture.debugElement.nativeElement)
                    .toHaveText("greet naomi | hello naomi");
                expect(location.urlChanges).toEqual(["/user/naomi"]);
                async.done();
              });
              clickOnElement(getLinkElement(fixture));
            });
      }));
  it(
      "should navigate between components with different parameters",
      inject([AsyncTestCompleter], (async) {
        compile(tcb)
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/user/:name", component: UserCmp, name: "User")
                ]))
            .then((_) => rtr.navigateByUrl("/user/brian"))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("hello brian");
            })
            .then((_) => rtr.navigateByUrl("/user/igor"))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("hello igor");
              async.done();
            });
      }));
}

syncRoutesWithSyncChildrenWithoutDefaultRoutesWithoutParams() {
  var fixture;
  var tcb;
  var rtr;
  beforeEachProviders(() => TEST_ROUTER_PROVIDERS);
  beforeEach(inject([TestComponentBuilder, Router], (tcBuilder, router) {
    tcb = tcBuilder;
    rtr = router;
  }));
  it(
      "should navigate by URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb, '''outer { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/a/...", component: ParentCmp, name: "Parent")
                ]))
            .then((_) => rtr.navigateByUrl("/a/b"))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("outer { inner { hello } }");
              async.done();
            });
      }));
  it(
      "should navigate by link DSL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb, '''outer { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/a/...", component: ParentCmp, name: "Parent")
                ]))
            .then((_) => rtr.navigate(["/Parent", "Child"]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("outer { inner { hello } }");
              async.done();
            });
      }));
  it(
      "should generate a link URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb,
                '''<a [routerLink]="[\'Parent\', \'Child\']">nav to child</a> | outer { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/a/...", component: ParentCmp, name: "Parent")
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(getHref(getLinkElement(fixture))).toEqual("/a/b");
              async.done();
            });
      }));
  it(
      "should navigate from a link click",
      inject([AsyncTestCompleter, Location], (async, location) {
        compile(tcb,
                '''<a [routerLink]="[\'Parent\', \'Child\']">nav to child</a> | outer { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/a/...", component: ParentCmp, name: "Parent")
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("nav to child | outer {  }");
              rtr.subscribe((_) {
                fixture.detectChanges();
                expect(fixture.debugElement.nativeElement)
                    .toHaveText("nav to child | outer { inner { hello } }");
                expect(location.urlChanges).toEqual(["/a/b"]);
                async.done();
              });
              clickOnElement(getLinkElement(fixture));
            });
      }));
}

syncRoutesWithSyncChildrenWithoutDefaultRoutesWithParams() {
  var fixture;
  var tcb;
  var rtr;
  beforeEachProviders(() => TEST_ROUTER_PROVIDERS);
  beforeEach(inject([TestComponentBuilder, Router], (tcBuilder, router) {
    tcb = tcBuilder;
    rtr = router;
  }));
  it(
      "should navigate by URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb, '''{ <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/team/:id/...", component: TeamCmp, name: "Team")
                ]))
            .then((_) => rtr.navigateByUrl("/team/angular/user/matias"))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("{ team angular | user { hello matias } }");
              async.done();
            });
      }));
  it(
      "should navigate by link DSL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb, '''{ <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/team/:id/...", component: TeamCmp, name: "Team")
                ]))
            .then((_) => rtr.navigate([
                  "/Team",
                  {"id": "angular"},
                  "User",
                  {"name": "matias"}
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("{ team angular | user { hello matias } }");
              async.done();
            });
      }));
  it(
      "should generate a link URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb,
                '''<a [routerLink]="[\'/Team\', {id: \'angular\'}, \'User\', {name: \'matias\'}]">nav to matias</a> { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/team/:id/...", component: TeamCmp, name: "Team")
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(getHref(getLinkElement(fixture)))
                  .toEqual("/team/angular/user/matias");
              async.done();
            });
      }));
  it(
      "should navigate from a link click",
      inject([AsyncTestCompleter, Location], (async, location) {
        compile(tcb,
                '''<a [routerLink]="[\'/Team\', {id: \'angular\'}, \'User\', {name: \'matias\'}]">nav to matias</a> { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/team/:id/...", component: TeamCmp, name: "Team")
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("nav to matias {  }");
              rtr.subscribe((_) {
                fixture.detectChanges();
                expect(fixture.debugElement.nativeElement).toHaveText(
                    "nav to matias { team angular | user { hello matias } }");
                expect(location.urlChanges)
                    .toEqual(["/team/angular/user/matias"]);
                async.done();
              });
              clickOnElement(getLinkElement(fixture));
            });
      }));
}

syncRoutesWithSyncChildrenWithDefaultRoutesWithoutParams() {
  var fixture;
  var tcb;
  var rtr;
  beforeEachProviders(() => TEST_ROUTER_PROVIDERS);
  beforeEach(inject([TestComponentBuilder, Router], (tcBuilder, router) {
    tcb = tcBuilder;
    rtr = router;
  }));
  it(
      "should navigate by URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb, '''outer { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/a/...",
                      component: ParentWithDefaultCmp,
                      name: "Parent")
                ]))
            .then((_) => rtr.navigateByUrl("/a"))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("outer { inner { hello } }");
              async.done();
            });
      }));
  it(
      "should navigate by link DSL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb, '''outer { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/a/...",
                      component: ParentWithDefaultCmp,
                      name: "Parent")
                ]))
            .then((_) => rtr.navigate(["/Parent"]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("outer { inner { hello } }");
              async.done();
            });
      }));
  it(
      "should generate a link URL",
      inject([AsyncTestCompleter], (async) {
        compile(tcb,
                '''<a [routerLink]="[\'/Parent\']">link to inner</a> | outer { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/a/...",
                      component: ParentWithDefaultCmp,
                      name: "Parent")
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(getHref(getLinkElement(fixture))).toEqual("/a");
              async.done();
            });
      }));
  it(
      "should navigate from a link click",
      inject([AsyncTestCompleter, Location], (async, location) {
        compile(tcb,
                '''<a [routerLink]="[\'/Parent\']">link to inner</a> | outer { <router-outlet></router-outlet> }''')
            .then((rtc) {
              fixture = rtc;
            })
            .then((_) => rtr.config([
                  new Route(
                      path: "/a/...",
                      component: ParentWithDefaultCmp,
                      name: "Parent")
                ]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("link to inner | outer {  }");
              rtr.subscribe((_) {
                fixture.detectChanges();
                expect(fixture.debugElement.nativeElement)
                    .toHaveText("link to inner | outer { inner { hello } }");
                expect(location.urlChanges).toEqual(["/a/b"]);
                async.done();
              });
              clickOnElement(getLinkElement(fixture));
            });
      }));
}

syncRoutesWithDynamicComponents() {
  var fixture;
  var tcb;
  Router rtr;
  beforeEachProviders(() => TEST_ROUTER_PROVIDERS);
  beforeEach(inject([TestComponentBuilder, Router], (tcBuilder, router) {
    tcb = tcBuilder;
    rtr = router;
  }));
  it(
      "should work",
      inject([AsyncTestCompleter], (async) {
        tcb
            .createAsync(DynamicLoaderCmp)
            .then((rtc) {
              fixture = rtc;
            })
            .then(
                (_) => rtr.config([new Route(path: "/", component: HelloCmp)]))
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement).toHaveText("{  }");
              return fixture.componentInstance.onSomeAction();
            })
            .then((_) {
              fixture.detectChanges();
              return rtr.navigateByUrl("/");
            })
            .then((_) {
              fixture.detectChanges();
              expect(fixture.debugElement.nativeElement)
                  .toHaveText("{ hello }");
              return fixture.componentInstance.onSomeAction();
            })
            .then((_) {
              // TODO(i): This should be rewritten to use NgZone#onStable or

              // something

              // similar basically the assertion needs to run when the world is

              // stable and we don't know when that is, only zones know.
              PromiseWrapper.resolve(null).then((_) {
                fixture.detectChanges();
                expect(fixture.debugElement.nativeElement)
                    .toHaveText("{ hello }");
                async.done();
              });
            });
      }));
}

registerSpecs() {
  specs["syncRoutesWithoutChildrenWithoutParams"] =
      syncRoutesWithoutChildrenWithoutParams;
  specs["syncRoutesWithoutChildrenWithParams"] =
      syncRoutesWithoutChildrenWithParams;
  specs["syncRoutesWithSyncChildrenWithoutDefaultRoutesWithoutParams"] =
      syncRoutesWithSyncChildrenWithoutDefaultRoutesWithoutParams;
  specs["syncRoutesWithSyncChildrenWithoutDefaultRoutesWithParams"] =
      syncRoutesWithSyncChildrenWithoutDefaultRoutesWithParams;
  specs["syncRoutesWithSyncChildrenWithDefaultRoutesWithoutParams"] =
      syncRoutesWithSyncChildrenWithDefaultRoutesWithoutParams;
  specs["syncRoutesWithDynamicComponents"] = syncRoutesWithDynamicComponents;
}
