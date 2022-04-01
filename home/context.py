"""Return the context of the views in the home section."""
import datetime
import typing
from dotmap import DotMap
from Website.settings import DEBUG

DOTMAP = typing.TypeVar('DotMap', bound=typing.OrderedDict)


author = DotMap({
    "first_name": "Valentin",
    "last_name": "Colin",
    "mail": "valentin.colin78@gmail.com",
    "birth_year": 2000,
    "birth_month": 3,
    "birth_day": 14,
    "phone_number": "(+33) 06.43.51.58.30",
    "github": {
        "url": "https://github.com/valentincolin/",
    },
    "linkedin": {
        "url": "https://www.linkedin.com/in/valentin-colin-522193152",
    },
})



def get_age(year: int, month: int, day: int) -> int:
    """Return the age computed."""
    birth = datetime.datetime(year=year, month=month, day=day)
    now = datetime.datetime.now()
    delta = now - birth
    return delta.days // 365


def set_author_computed_informations(_author: DOTMAP) -> None:
    _author.name = _author.first_name + " " + _author.last_name
    _author.age = get_age(year=_author.birth_year, month=_author.birth_month, day=_author.birth_day)


def home_context(request) -> DOTMAP:
    """Return the home context."""
    set_author_computed_informations(author)
    context = DotMap({
        "author": author,
    })
    return context


def hydrate(*context_getters, debug=False):
    """Double decorator that updates the context."""

    def view_decorator(view):
        """Decorator view."""

        def view_decorated(request, *args, context: DOTMAP = {}, **kwargs):
            """Decorated view."""
            context_hydrated = {}
            for context_getter in context_getters:
                context_hydrated.update(context_getter(request))
            context.update(context_hydrated)
            if DEBUG:
                print(f"[DEBUG] Context:")
                print(context)
            return view(request, *args, context=context, **kwargs)

        return view_decorated

    return view_decorator
