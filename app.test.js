const request = require('supertest');
const app = require('./index');

describe('Parkoló API tesztek', () => {

    test('GET /api/parkolo - visszaad egy tömböt', async () => {
        const res = await request(app).get('/api/parkolo');

        expect(res.statusCode).toBe(200);
        expect(Array.isArray(res.body)).toBe(true);
    });

    test('GET /api/szabadparkolo - allapot = 0', async () => {
        const res = await request(app).get('/api/szabadparkolo');

        expect(res.statusCode).toBe(200);
        expect(Array.isArray(res.body)).toBe(true);

        if (res.body.length > 0) {
            expect(res.body[0].allapot).toBe(0);
        }
    });

    test('POST /api/jarmu - új Audi jármű létrehozása', async () => {
    const ujJarmu = {
        rendszam: 'AUD-001',
        szin: 'fekete',
        tipus: 'Audi',
        tulajdonos: 'Teszt Elek'
    };

    const res = await request(app)
        .post('/api/jarmu')
        .send(ujJarmu)
        .set('Accept', 'application/json');

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('insertId');
    });

});
