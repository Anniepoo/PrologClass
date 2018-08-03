:- use_module(planner).
:- use_module(story_data).
:- use_module(story_dcg_html).
:- use_module(story_generator).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).

:- http_handler(/, home_page, []).
:- http_handler('/story', story_page, []).

home_page(_Request) :-
    reply_html_page([title('Story Generator')],
                    [   h1('Story Generator')
                    ,   form([ method(get), action(story) ],
                             [ div(label([ 'Name of Character: '
                                         , input([ type(text), name(name), required ])
                                         ]))
                             , div(label([ 'Name of Pet: '
                                         , input([ type(text), name(pet), required ])
                                         ]))
                             , div(label([ 'Type of Animal: '
                                         , input([ type(text), name(animal), required ])
                                         ]))
                             , input([ type(submit) ])
                             ])
                    ,   p([ a(href('/story'), 'Click here')
                          , ' to generate a story.'
                          ])
                    ]
                    ).

story_page(Request) :-
    http_parameters(Request,
        [   name(Name,      [optional, default('Brian')])
        ,   pet(Pet,        [optional, default('Murray')])
        ,   animal(Animal,  [optional, default('cat')])
        ]),
    init(Name, Pet, Animal, State),
    generate_story(State, Story),
    phrase(story(Story), StoryHtml),
    !,
    reply_html_page([title('A Story')], 
                    [  h1('A Story')
                    ,  div([class(story)], StoryHtml)
                    ]).

go :-
    Port = 8080,
    http_server(http_dispatch, [port(Port)]).

% vim: et ts=4 sw=4 ai
