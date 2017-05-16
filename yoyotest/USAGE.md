# API DOCS


### Introduction

    
"You cannot make a to-do without taking a note."

It means that you must notice first before taking action. If you notice* or "take note" that your head is somewhat itchy, what you want "to do" is to check the cause of itch, by scratching and looking at mirror. Then you notice that your head is like winter season, there is snow falling. You also see that your shoulder has snow. Now what you plan "to do" is to buy "Head and Shoulders" anti-dandruff shampoo. Upon noticing that you have bad odor as you look onto your shoulders, you feel that what you need to do is to TAKE A BATH! No wonder why you have dandruff, you were too concentrated on software development that you forget to take a bath!

**notice is synonymous with "take note"*

### The Entities

There are entities:
1. Notes
2. Todos
3. Users

#### Notes

Notes have these attributes:
1. `id` - The unique identifier
2. `title` - The gist of what you have taken note
3. `content` - The content of the note
4. `created_at` - "When did you write this?"
5. `username` - The owner

#### Todos

Todos have these attributes:
1. `note_id` - Every todo is a note. You cannot make a todo without taking notes
2. `task` - Description of what you must do or intend to do
3. `target_datetime` - "YYYY-MM-DD HH:MM:SS", When must you finish it?
4. `created_at` - When did you decide "to do" something?
5. All attributes of the note except the `id` and `created_at`

#### Users

1. `username`, `password`, `email`, `first_name`, `last_name`


### What you need to know
If you wish to access a resource that involves inputting form data or searching by filter, the user must send an HTTP request that has the following JSON BODY:

```
{
    "input_data" : {
        "username" : "cmoran"
        "title" : "A sample note title"
        "content" : "Lorem ipsum dolor sit amet. This is a dummy note"
    },
}
```

OR 

```
{
    "search_filter" : {
        "username" : "cmoran"
        "title" : "Is there a note with a title like this?"
    },
}
```



## API Resources

NOTE: Route parameters are indicated as `:parameter`. The CRUD resources of notes and todos cannot be accessed unless the user logs in. 

### Misc

#### POST/PUT /api/login

You just need a Form URL encoded body that contains the following data: "username" and "password"

#### ANY /api/logout

No body is needed

---

### Notes 

#### GET /api/notes

You need a JSON body that has an item called "search_filter", which is a JSON of key-value pairs derived from form data. Only what the logged in user owns will appear.

Such as:
```
{
    "search_filter": {
        "title" :  "I am a NOTE to be DELETED"
    }
}
```

#### GET /api/notes/:id

No body is needed. Fetch one note by `id`

#### POST /api/notes

You need a JSON body that has an item called "input_data", which is a JSON of key-value pairs derived from form data.

Such as:
```
{
    "input_data": {
        "title" :  "I am a NOTE to be MADE",
        "content" : "Here is the innards"  
    }
}
```

#### PUT /api/notes/:id

Just like `POST /api/notes`, you need such body. This time refer to the note of the one you must update.

#### DELETE /api/notes/:id

Delete a note

#### PUT/POST /api/notes/:id/convert

Search for a note to be converted to a todo. You'll need some data to input.


```
{
    "input_data": {
        "task" : "YAY Conversion!",
        "target_datetime": "2017-05-16 12:00:00"
    }
}
```

---

### Todos

#### GET /api/todos

You need a JSON body that has an item called "search_filter", which is a JSON of key-value pairs derived from form data. Only what the logged in user owns will appear.

Such as:
```
{
    "search_filter": {
        "task" :  "Go to WalMart"
    }
}
```

#### GET /api/todos/:id

No body is needed. Fetch one todo by `id`

#### POST /api/todos

You need a JSON body that has an item called "input_data", which is a JSON of key-value pairs derived from form data. `target_datetime` can be null.

Such as:
```
{
    "input_data" : {
        "title": "Testing Todo Creation",
        "content": "Lorem ipsum dolor sit amet... POST TODO",
        "task": "Test the creation",
        "target_datetime": "2017-05-12 12:00"
    }
}
```

#### PUT /api/todos/:id

Just like `POST /api/todos`, you need such body. This time refer to the note of the one you must update.

#### DELETE /api/todos/:id

Delete a todo

#### PUT/POST /api/notes/:id/convert

Search for a todo to be converted to a note. No body is needed.

#### PUT/POST /api/todos/8/done

Marks a todo as done.

#### DELETE /api/todos/8/done

Marks a todo as not done.
