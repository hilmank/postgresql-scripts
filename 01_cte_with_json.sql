WITH rekap_triwulan AS (
    SELECT
        d.name AS nama_element,
        count(c.id_element) jumlah_unsur,
        sum(c.value) jumlah_nilai_paramater,
        sum(c.value) / count(c.id_element) :: decimal nilai_rata_rata_parameter,
        (sum(c.value) / count(c.id_element) :: decimal) * 0.11 nilai_indeks_parameter
    FROM
        j_user a
        JOIN j_questionnaire b ON a.id = b.created_by_user_id
        JOIN pv_questionnaire c ON b.id = c.id_questionnaire
        JOIN m_element d ON c.id_element = d.id
    WHERE
        date_part('year', a.created_at) = 2024
        AND date_part('month', a.created_at) BETWEEN 1
        AND 3
    GROUP BY
        nama_element
)
SELECT
    json_build_object(
        'data',
        jsonb_agg(
            json_build_object(
                'element',
                nama_element,
                'nilai_rata_rata_parameter',
                nilai_rata_rata_parameter,
                'indeks',
                CASE
                    WHEN nilai_rata_rata_parameter BETWEEN 1.00
                    AND 1.75 THEN 'Tidak Baik'
                    WHEN nilai_rata_rata_parameter BETWEEN 1.76
                    AND 2.50 THEN 'Kurang Baik'
                    WHEN nilai_rata_rata_parameter BETWEEN 2.51
                    AND 3.25 THEN 'Baik'
                    ELSE 'Sangat Baik'
                END
            )
        ),
        'nilai_ikm',
        sum(nilai_indeks_parameter),
        'status_ikm',
        CASE
            WHEN sum(nilai_indeks_parameter) BETWEEN 0.00
            AND 1.75 THEN 'Tidak Baik'
            WHEN sum(nilai_indeks_parameter) BETWEEN 1.76
            AND 2.50 THEN 'Kurang Baik'
            WHEN sum(nilai_indeks_parameter) BETWEEN 2.51
            AND 3.25 THEN 'Baik'
            ELSE 'Sangat Baik'
        END,
        'nilai_skm',
        sum(nilai_indeks_parameter) * 25,
        'status_skm',
        CASE
            WHEN sum(nilai_indeks_parameter) * 25 BETWEEN 0.00
            AND 64.99 THEN 'Tidak Baik'
            WHEN sum(nilai_indeks_parameter) * 25 BETWEEN 65.00
            AND 76.60 THEN 'Kurang Baik'
            WHEN sum(nilai_indeks_parameter) * 25 BETWEEN 76.61
            AND 88.30 THEN 'Baik'
            ELSE 'Sangat Baik'
        END
    ) AS ret
FROM
    rekap_triwulan;