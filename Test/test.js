const request = require('supertest');
const app = require('./index');

describe('Backend integrációs tesztek', () => {

    it('GET /api/parkolo - parkolók lekérése', async () => {
        const res = await request(app).get('/api/parkolo');

        expect(res.statusCode).toBe(200);
        expect(Array.isArray(res.body)).toBe(true);

        if (res.body.length > 0) {
            expect(res.body[0]).toHaveProperty('id');
            expect(res.body[0]).toHaveProperty('allapot');
        }
    });

    it('POST /api/jarmu - új jármű létrehozása', async () => {
        const newJarmu = {
            rendszam: 'XXX-987',
            szin: 'lila',
            tipus: 'Suzuki',
            tulajdonos: 'Asd'
        };

        const res = await request(app)
            .post('/api/jarmu')
            .send(newJarmu)
            .set('Content-Type', 'application/json');

        expect(res.statusCode).toBe(200);
        expect(res.body).toHaveProperty('insertId');
    });

});
