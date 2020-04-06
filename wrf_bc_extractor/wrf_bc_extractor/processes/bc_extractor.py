from pywps import Process, LiteralInput, LiteralOutput, UOM, ComplexInput, ComplexOutput, Format, FORMATS
from pywps.app.Common import Metadata

import logging
LOGGER = logging.getLogger("PYWPS")

import os
import subprocess

# https://github.com/bird-house/flyingpigeon/blob/master/flyingpigeon/processes/wps_subset_countries.py
from pywps.inout.outputs import MetaFile, MetaLink4

metalink = ComplexOutput('metalink',
                         'Metalink file with links to all BC outputs.',
                         as_reference=True,
                         supported_formats=[FORMATS.META4])
outlog = LiteralOutput('stdout', 'stdout', data_type='string')
errlog = LiteralOutput('stderr', 'stderr', data_type='string')

class BCExtractor(Process):
    """BC WRF Extractor"""
    def __init__(self):
        inputs = [
            ComplexInput('bc_table', 'BC table',
                         abstract='BCtable',
                         min_occurs=1,
                         max_occurs=1,
                         supported_formats=[
                             Format('text/plain'),
                         ]),
        ]

        outputs = [metalink, outlog, errlog]

        super(BCExtractor, self).__init__(
            self._handler,
            identifier='bcextractor',
            title='BC Extractor',
            abstract='Boundary Condition extractor for WRF model',
            keywords=['WRF', 'boundary'],
            metadata=[
                Metadata('PyWPS', 'https://pywps.org/'),
                Metadata('Birdhouse', 'http://bird-house.github.io/'),
                Metadata('PyWPS Demo', 'https://pywps-demo.readthedocs.io/en/latest/'),
                Metadata('Emu: PyWPS examples', 'https://emu.readthedocs.io/en/latest/'),
            ],
            version='1.5',
            inputs=inputs,
            outputs=outputs,
            store_supported=True,
            status_supported=True
        )

    @staticmethod
    def _handler(request, response):
        LOGGER.info("Extract boundary conditions")

        bc_table = request.inputs['bc_table'][0].file

        command = ["../preprocessor.ESGF", "2033-12-24_00:00:00", "2033-12-30_00:00:00", "/oceano/gmeteo/WORK/ASNA/DATA/CanESM2", bc_table]
        bc = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        outlog = bc.stdout.decode("utf-8")
        errlog = bc.stderr.decode("utf-8")
        
        try:
            ml = MetaLink4('bc', workdir="grbData")
            for f in os.listdir("/oceano/gmeteo/WORK/ASNA/projects/cordex4cds/v2/grbData"):
                mf = MetaFile(os.path.basename(f), fmt=FORMATS.META4)
                mf.file = os.path.join("/oceano/gmeteo/WORK/ASNA/projects/cordex4cds/v2/grbData", f)
                ml.append(mf)
        except Exception as ex:
            msg='BC failed: {}'.format(str(ex))
            LOGGER.exception(msg)
            raise Exception(msg)
        
        response.outputs['metalink'].data = ml.xml
        response.outputs['stdout'].data = outlog
        response.outputs['stderr'].data = errlog
        response.update_status("Completed", 100)
        return response
