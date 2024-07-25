SELECT
    m.id AS "ID",
    m.title AS "Title",
    m.release_date AS "Release date",
    m.duration AS "Duration",
    m.description AS "Description",
    json_build_object(
        'ID', f.id,
        'File_name', f.file_name,
        'Mime_type', f.mime_type,
        'File_key', f.file_key,
        'Url', f.url
    ) AS "Poster",
    json_build_object(
        'ID', d.id,
        'First name', d.first_name,
        'Last name', d.last_name
    ) AS "Director"
FROM
    movies m
JOIN
    countries c ON m.country_id = c.id 
JOIN 
    files f ON m.poster_id = f.id 
JOIN 
    persons d ON m.director_id = d.id 
JOIN
    movie_genres mg ON m.id = mg.movie_id
JOIN 
    genres g ON mg.genre_id = g.id 
WHERE
    m.country_id = 1
    AND m.release_date >= '2022-01-01'
    AND m.duration > (2 * 60 + 15) * 60
    AND g.name IN ('Action', 'Drama')
GROUP BY
    m.id, f.id, d.id, d.first_name, d.last_name
ORDER BY
    m.release_date DESC;