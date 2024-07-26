SELECT
    m.id AS "ID",
    m.title AS "Title",
    m.release_date AS "Release date",
    m.duration AS "Duration",
    m.description AS "Description",
    row_to_json(f) AS "Poster",
    json_build_object(
        'ID', d.id,
        'First name', d.first_name,
        'Last name', d.last_name,
        'Photo', row_to_json(pf)
    ) AS "Director",
    ARRAY_AGG(json_build_object(
        'ID', a.id,
        'First name', a.first_name,
        'Last name', a.last_name,
        'Photo', row_to_json(af)
    )) AS "Actors",
    ARRAY_AGG(json_build_object(
        'ID', g.id,
        'Name', g.name
    )) AS "Genres"
FROM
    movies m 
JOIN
    files f ON m.poster_id = f.id 
JOIN 
    persons d ON m.director_id = d.id 
LEFT JOIN 
    files pf ON d.primary_photo_id = pf.id 
LEFT JOIN 
    characters c ON m.id = c.movie_id
LEFT JOIN 
    persons a ON c.actor_id = a.id 
LEFT JOIN 
    files af ON a.primary_photo_id = af.id 
JOIN
    movie_genres mg ON m.id = mg.movie_id 
JOIN
    genres g ON mg.genre_id = g.id
WHERE
    m.id = 1
GROUP BY
    m.id, f.id, d.id, d.first_name, d.last_name, pf.id 
ORDER BY
    m.release_date DESC;