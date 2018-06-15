# Import Flask and Nemo
# This script can take a first argument giving a configuration from examples.py
from flask import Flask
from flask_nemo import Nemo
from flask_caching import Cache
from flask_nemo.chunker import level_grouper
from capitains_nautilus.cts.resolver import NautilusCTSResolver
from MyCapytain.resources.prototypes.cts.inventory import CtsTextInventoryCollection as TextInventoryCollection, CtsTextInventoryMetadata as PrototypeTextInventory
from MyCapytain.resolvers.utils import CollectionDispatcher
from capitains_nautilus.cts.resolver import NautilusCTSResolver
from capitains_nautilus.flask_ext import FlaskNautilus
import logging
# We import enough resources from MyCapytain to retrieve data
from MyCapytain.resolvers.cts.api import HttpCtsResolver
from MyCapytain.retrievers.cts5 import HttpCtsRetriever

# We create a Flask app
app = Flask(
    __name__
)

tic = TextInventoryCollection()
fro = PrototypeTextInventory("urn:geste", parent=tic) #Rien à voir avec les identifiants cts, c'est un identifiant de projet
fro.set_label("Corpus de chansons de geste", "fro")

dispatcher = CollectionDispatcher(tic)

@dispatcher.inventory("urn:geste")
def dispatchGeste(collection, path=None, **kwargs):
    if collection.id.startswith("urn:cts:froLit"): #et cette fois, c'est bien du cts et on file le début des chemins de citation.
        return True
    return False

cache = Cache()

NautilusDummy = NautilusCTSResolver(
    [
        "."
    ],
    dispatcher=dispatcher
)
NautilusDummy.logger.setLevel(logging.ERROR)

def scheme_grouper(text, getreffs):
    level = len(text.citation)
    groupby = 5
    types = [citation.name for citation in text.citation]

    if 'word' in types:
        types = types[:types.index("word")]
    if str(text.id) == "urn:cts:latinLit:stoa0040.stoa062.opp-lat1":
        level, groupby = 1, 2
    elif types == ["vers", "mot"]:
        level, groupby = 1, 100
    elif types == ["book", "poem", "line"]:
        level, groupby = 2, 1
    elif types == ["book", "line"]:
        level, groupby = 2, 30
    elif types == ["book", "chapter"]:
        level, groupby = 2, 1
    elif types == ["book"]:
        level, groupby = 1, 1
    elif types == ["line"]:
        level, groupby = 1, 30
    elif types == ["chapter", "section"]:
        level, groupby = 2, 2
    elif types == ["chapter", "mishnah"]:
        level, groupby = 2, 1
    elif types == ["chapter", "verse"]:
        level, groupby = 2, 1
    elif "line" in types:
        groupby = 30
    return level_grouper(text, getreffs, level, groupby)


nautilus = FlaskNautilus(
    app=app,
    prefix="/api",
    name="nautilus",
    resolver=NautilusDummy
)

nemo = Nemo(
    app=app,
    base_url="/geste",
    resolver=NautilusDummy,
    chunker={"default": scheme_grouper},
    plugins=None,
    cache=cache,
    transform={
        "default": "./geste.xslt"
    },
    css=[
        # USE Own CSS
        "./styles/geste.css"
    ],
    js=[
        # use own js file to load a script to go from normalized edition to diplomatic one.
        "./styles/geste.js"
    ],
    templates={
        "main": "./templates"
    },
    statics=["./images/logo-enc2.png","./fonts/Junicode-Regular.ttf","./fonts/Junicode-Regular.woff"]
    #,
    #additional_static=[
    #    "img/logo-enc2.jpg"
    #]
)

cache.init_app(app)
app["SERVER_NAME"] = "http://corpus.enc.sorbonne.fr/geste"

if __name__ == "__main__":
    app.run()
