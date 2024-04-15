--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Text.Pandoc


--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
  {
   destinationDirectory = "docs"
   , previewPort          = 5000
  }

main :: IO ()
main = hakyllWith config $ do
    match "static/*/*" $ do
        route idRoute
        compile copyFileCompiler

    match (fromList ["about.md", "contact.md", "hire-me.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html" siteCtx
            >>= loadAndApplyTemplate "templates/default.html" siteCtx
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    siteCtx

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    siteCtx

siteCtx :: Context String
siteCtx =
    constField "baseurl" "http://127.0.0.1:5000" `mappend`
    constField "site_description" "Welcome to my world of innovation and excellence, where every line of code tells a story of passion and expertise." `mappend`
    constField "instagram_url" "https://instagram.com/kayisrahman" `mappend`
    constField "twitter_url" "https://twitter.com/kayisrahman" `mappend`
    constField "github_url" "https://github.com/kayis-rahman" `mappend`
    constField "linkedin_url" "https://in.linkedin.com/in/kayisrahman" `mappend`
    defaultContext
